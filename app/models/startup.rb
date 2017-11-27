class Startup < ActiveRecord::Base
  require 'spreadsheet'

  acts_as_paranoid

  STEPS = %w[overview vitals focus strategy brands]
  EVOLUTION = 'evolution'
  STARTUP_TYPES = %w[ founder_brand founder evolution evo_generated founder_evolution ]
  MONTHS_INTERVAL = 11

  enum startup_type: [:evolution, :brand, :founder]

  attr_writer :current_step
  attr_accessor :month, :year, :skip_validation
  alias_attribute :_id, :id
  alias_attribute :complete?, :is_complete

  belongs_to   :owner, class_name: 'User',
                       foreign_key: :owner_id, dependent: :destroy
  has_many     :startup_watchers
  has_many     :watchers, through: :startup_watchers,
                          source: :user, validate: false
  has_many     :founders
  has_many     :startup_brief_summaries
  has_many     :profile_questions, foreign_key: :startup_id,
                                   class_name: 'StartupProfileQuestion'
  has_many     :brand_startups
  has_many     :pushed_to_brands, through: :brand_startups,
                                  source: :brand

  has_many     :list_startups
  has_many     :lists, through: :list_startups
  has_many     :startup_tags, dependent: :destroy
  has_many     :tags, through: :startup_tags
  has_many     :notes, -> { where assignee_id: nil }
  has_many     :tasks, -> { where.not assignee_id: nil }, class_name: 'Note'
  has_many     :requests
  has_many     :brand_briefs, class_name: 'StartupBrandBrief'
  has_many     :brands, through: :promo_briefs
  has_many     :promo_briefs, class_name: 'StartupPromoBrief'
  has_many     :promo_pages, through: :promo_briefs
  has_many     :activities, -> { where resource_type: UserActivity.resource_types[:startup] },
                            class_name: 'UserActivity', foreign_key: :resource_id,
                            dependent: :destroy

  has_one      :invite, foreign_key: :resource_id, dependent: :destroy
  belongs_to   :updater, class_name: 'User', foreign_key: :updater_id
  belongs_to   :creator, class_name: 'User', foreign_key: :creator_id
  has_many     :scorecards, dependent: :destroy
  has_many     :pdf_documents, class_name: 'StartupPdf', dependent: :destroy

  accepts_nested_attributes_for :founders, allow_destroy: true

  validates :title, presence: true
  validates :location, :date_founded, :founders, :elevator_pitch, :website, :logo,
            presence: true, unless: :skip_validation
  validates :elevator_pitch, :frame_of_reference, length: { maximum: 255 }
  # validates :website, format: URI::regexp(%w(http https)), unless: :skip_validation
  # validates :video_url, format: URI::regexp(%w(http https)), allow_blank: true
  validates_format_of :twitter, with: /\A@*([a-zA-Z](_?[a-zA-Z0-9]+)*_?|_([a-zA-Z0-9]+_?)*)$\Z/i,
                                allow_blank: true

  delegate :full_name, to: :owner, prefix: true, allow_nil: true
  delegate :email, to: :owner, prefix: true, allow_nil: true

  before_validation :form_founded_date
  before_validation :strip_whitespace
  after_commit :rebuild_indexes

  mount_uploader :logo, PictureUploader

  scope :search_by_title, -> (search) { where('lower(title) like ?', "%#{search.downcase}%")}

  scope :entry_history, -> do
    where('startups.created_at > DATE_SUB(?, INTERVAL ? MONTH)', DateTime.now.to_date, MONTHS_INTERVAL)
    .group('YEAR(startups.created_at)', 'MONTH(startups.created_at)')
    .order(created_at: :desc)
    .count('startups.id')
  end

  scope :watchlist, -> (user) do
    if user.brand_team?
      eager_load(:brand_startups)
      .where('startups.owner_id IS NULL AND startups.creator_id IN (?)',
             user.brand_user_ids)
    else
      where(owner_id: nil, prefilled_brief: false, creator_id: User.evo_users.pluck(:id))
    end
  end

  scope :all_startups, -> (user) do
    if user.brand_team?
      team_mates = user.brand_user_ids
      eager_load(:promo_briefs, :brand_startups, owner: [:invite])
      .where('owner_id IS NOT NULL AND invites.sent_by IN (:team_mates)
        OR startups.owner_id IS NULL AND creator_id IN (:team_mates)
        OR brand_startups.id IS NOT NULL AND brand_startups.brand_id = :brand_id
        OR startup_promo_briefs.promo_page_id IN (:promo_pages_ids)',
        { team_mates: team_mates, brand_id: user.brand.id,
          evo_users: User.evo_users.pluck(:id), promo_pages_ids: user.brand.promo_page_ids })
    else
      where('owner_id IS NULL AND startups.creator_id NOT IN (?)
        OR owner_id IS NOT NULL', User.brand_users.pluck(:id))
    end
  end

  scope :evo_generated, -> (user) do
    where('prefilled_brief = ? AND owner_id IS NULL', true)
  end

  scope :evo_generated_confirmed, -> (user) do
    where('prefilled_brief = ? AND owner_id IS NULL', true)
  end


  scope :founder, -> (user) do
    if user.brand_team?
      eager_load(:promo_briefs, owner: [:invite]).where('owner_id IS NOT NULL AND invites.sent_by IN (?)
        OR startup_promo_briefs.promo_page_id IN (?)', user.brand_user_ids, user.brand.promo_page_ids)
    end
  end

  scope :founder_confirmed, -> (user) do
    founder(user).confirmed
  end

  scope :evolution, -> (user) do
    if user.brand_team?
      joins(:brand_startups)
        .where(brand_startups: { brand_id: user.brand.id })
    end
  end

  scope :evolution_confirmed, -> (user) do
    evolution(user).confirmed
  end

  scope :founder_evolution, -> (user) do
    startup_table = Startup.arel_table
    user_table = User.arel_table
    invite_table = Invite.arel_table
    startup_promo_brief_table = StartupPromoBrief.arel_table

    joins(startup_table.join(startup_promo_brief_table, Arel::Nodes::OuterJoin).
              on(startup_table[:id].eq(startup_promo_brief_table[:startup_id])).
              join_sources,
          startup_table.join(user_table, Arel::Nodes::InnerJoin).
              on(user_table[:id].eq(startup_table[:owner_id])).
              join_sources,
          user_table.join(invite_table, Arel::Nodes::OuterJoin).
              on(invite_table[:id].eq(user_table[:invite_token_id])).
              join_sources)
    .where(startup_table[:owner_id].not_eq( nil ).
             and(invite_table[:sent_by].in( User.evo_users.pluck(:id) )).
             or(startup_table[:owner_id].not_eq( nil ).
                and(startup_promo_brief_table[:promo_page_id].eq( nil )).
                and(user_table[:invite_token_id].eq( nil ))))
  end

  scope :founder_evolution_confirmed, -> (user) do
    founder_evolution(user).confirmed
  end

  scope :founder_brand, -> (user) do
    eager_load(:promo_briefs, owner: [:invite])
    .where('owner_id IS NOT NULL AND invites.sent_by IN (?)
            OR startup_promo_briefs.promo_page_id IS NOT NULL', User.brand_users.pluck(:id))
  end

  scope :founder_brand_confirmed, -> (user) do
    founder_brand(user).confirmed
  end

  scope :submission_startups, -> { where(startup_type: startup_types[:founder]) }
  scope :evolution_startups, -> { where(startup_type: startup_types[:evolution]) }
  scope :manual_startups, -> (user) do
    eager_load(:startup_watchers)
      .where('startups.creator_id = ? OR startup_watchers.watcher_id = ?', user,
             user)
  end
  scope :query_startups, -> (startups) do
    startups.nil? ? Startup.none : where(id: startups)
  end

  # scope :top_categories, -> do
  #   joins(startup_brief_summaries: [{ brief_answer: [{ category_value: [:category] }] }])
  #   .where('categories.alias = ? ', 'tech_sectors')
  #   .group('category_values.id, category_values.content')
  #   .order('COUNT(category_values.id) DESC')
  #   .limit(3).count('category_values.id')
  # end

  scope :top_categories, -> do
    Startup.joins(startup_brief_summaries: [{ brief_answer: [{ category_value: [:category] }] }])
      .where('categories.alias = ? ', 'tech_sectors')
      .group('category_values.id, category_values.content')
      .order('COUNT(category_values.id) DESC')
      .limit(3).select(
        'category_values.id AS id',
        'category_values.content AS content',
        'category_values.icon_name AS icon_name',
        'COUNT(category_values.id) AS count'
      )
  end

  scope :unconfirmed, -> { joins(:owner).where(users: { confirmed_at: nil }) }

  scope :confirmed, -> { joins(:owner).where.not(users: { confirmed_at: nil }) }

  scope :all_confirmed, -> do
    joins('LEFT JOIN users ON users.id = startups.owner_id')
      .where('prefilled_brief = ? AND owner_id IS NULL OR users.confirmed_at IS NOT NULL', true)
  end

  def confirmed?
    owner.nil? || !owner.try(:confirmed_at).nil?
  end

  def initial
    title[0, 1] if title
  end

  def current_step
    @current_step || STEPS.first
  end

  def next_step
    self.current_step = STEPS[STEPS.index(current_step) + 1]
  end

  def previous_step
    self.current_step = STEPS[STEPS.index(current_step) - 1]
  end

  def first_step?
    self.current_step == STEPS.first
  end

  def last_step?
    self.current_step == STEPS.last
  end

  #method for forming startup results of the setup-profile stage
  def form_brief_results
    summary = {}
    brief_summaries = startup_brief_summaries.where(startup_promo_brief_id: nil,
                                  startup_brand_brief_id: nil)
                                 .includes(:brief_answer, :brief_question,
                                            brief_answer: :category_value)
    brief_summaries.each do |result|
      alias_key = result.brief_question.alias.to_sym
      if result.brief_answer.nil?
        summary[alias_key] = result.answer_text
      else
        if summary[alias_key].nil?

          summary[alias_key] = [{
              content: result.brief_answer.category_value.content,
              icon_name: result.brief_answer.category_value.icon_name,
              detail: result.detail_text
          }]
        else
          summary[alias_key] << {
              content: result.brief_answer.category_value.content,
              icon_name: result.brief_answer.category_value.icon_name,
              detail: result.detail_text
          }
        end
      end
    end
    summary
  end

  def form_promo_answers(promo_page_ids=nil)
    summary = {}
    promo_results_collection(promo_page_ids).each do |result|
      promo_page_id = result.startup_promo_brief.promo_page_id
      id_key = result.promo_question.id
      summary[promo_page_id] = {} if summary[promo_page_id].blank?
      if result.promo_answer.nil?
        summary[promo_page_id][id_key] = result.answer_text
      else
        if summary[promo_page_id][id_key].nil?
          summary[promo_page_id][id_key] = [result.promo_answer.answer_text]
        else
          summary[promo_page_id][id_key] << result.promo_answer.answer_text
        end
      end
    end
    summary
  end

  def form_answers_result(step)
    summary = HashWithIndifferentAccess.new
    startup_brief_summaries.includes(:brief_answer, :brief_question,
                                      brief_answer: :category_value)
                           .where(startup_promo_brief_id: nil, startup_brand_brief_id: nil)
                           .each do |result|
      next unless result.brief_question.progress_step == step
      alias_key = result.brief_question.alias.to_sym
      if result.brief_answer.nil?
        summary[alias_key] = result.answer_text
      else
        if summary[alias_key].nil?
          summary[alias_key] = [result.brief_answer.id]
          summary[alias_key] = { answers: startup_brief_summaries
                                            .where(question_id: result.question_id,
                                                   startup_promo_brief_id: nil,
                                                   startup_brand_brief_id: nil)
                                            .joins(:brief_answer)
                                            .pluck(:'startup_brief_answers.id'),
                                 detail: result.detail_text } if result.brief_question.detail
        else
          summary[alias_key] << result.brief_answer.id unless result.brief_question.detail
        end
      end
    end
    summary
  end

  def form_promo_results
    summary = HashWithIndifferentAccess.new
    startup_brief_summaries.where.not(startup_promo_brief_id: nil)
                           .where(startup_brand_brief_id: nil)
                           .includes(:promo_answer, :promo_question,
                                      :startup_promo_brief).each do |result|
      promo_page_id = result.startup_promo_brief.promo_page_id
      id_key = result.promo_question.try :id

      summary[promo_page_id] = {} if summary[promo_page_id].blank?
      if id_key
        if result.promo_answer.nil?
          summary[promo_page_id][id_key] = result.answer_text
        else
          if summary[promo_page_id][id_key].nil?
            summary[promo_page_id][id_key] = [result.promo_answer.id]
          else
            summary[promo_page_id][id_key] << result.promo_answer.id
          end
        end
      end
    end
    summary
  end

  def form_brand_results(user_brand_id=nil)
    summary = {}
    brand_results_collection(user_brand_id).each do |result|
      brand_id = result.startup_brand_brief.brand_id
      id_key = result.brand_question.try :id

      summary[brand_id] = {} if summary[brand_id].blank?
      if id_key
        if result.brand_answer.nil?
          summary[brand_id][id_key] = result.answer_text
        else
          if summary[brand_id][id_key].nil?
            summary[brand_id][id_key] = [result.brand_answer.answer_text]
          else
            summary[brand_id][id_key] << result.brand_answer.answer_text
          end
        end
      end
    end
    summary
  end

  def brand_results_collection(user_brand_id)
    if user_brand_id.blank?
      startup_brief_summaries.where(startup_promo_brief_id: nil)
                             .where.not(startup_brand_brief_id: nil)
                             .includes(:brand_answer, :brand_question, :startup_brand_brief)
    else
      startup_brief_summaries.where(startup_promo_brief_id: nil)
                             .where.not(startup_brand_brief_id: nil)
                             .joins(:startup_brand_brief)
                             .where('startup_brand_briefs.brand_id' => user_brand_id)
                             .includes(:brand_answer, :brand_question, :startup_brand_brief)
    end
  end

  def promo_results_collection(promo_page_ids)
    if promo_page_ids.blank?
      startup_brief_summaries.where.not(startup_promo_brief_id: nil)
                              .where(startup_brand_brief_id: nil)
                              .includes(:promo_answer, :promo_question, :startup_promo_brief)
    else
      startup_brief_summaries.where.not(startup_promo_brief_id: nil)
                              .where(startup_brand_brief_id: nil)
                              .joins(:startup_promo_brief)
                              .where('startup_promo_briefs.promo_page_id' => promo_page_ids)
                              .includes(:promo_answer, :promo_question, :startup_promo_brief)
    end
  end

  def form_founded_date
    return unless year && month
    unless year[1].blank? || month[2].blank?
      self.date_founded = DateTime.new(year[1], month[2])
    else
      errors.add(:year, "not a valid date") if year[1].blank? && !skip_validation
      errors.add(:month, "not a valid date") if month[2].blank? && !skip_validation
    end
  end

  def brief_summary
    return {} if startup_brief_summaries.empty?
    brief_result = {}
    startup_brief_summaries.main_brief.includes(:brief_answer, :brief_question,
      brief_answer: :category_value).each do |summary|
      key = summary.question_id.to_s
      answer_id = summary.answer_id.to_s
      if summary.brief_question.single?
        if summary.brief_question.detail?
          brief_result[key] = {
              'answer' => answer_id,
              'detail' => summary.detail_text }
        else
          brief_result[key] = answer_id
        end
      elsif summary.brief_question.multi?
        if summary.brief_question.detail?
          if brief_result.key?(key)
            brief_result[key]['answers'] << answer_id
          else
            brief_result[key] = {
                'answers' => [answer_id],
                'detail' => summary.detail_text }
          end
        else
          if brief_result.key?(key)
            brief_result[key] << answer_id
          else
            brief_result[key] = [answer_id]
          end
        end

      else
        brief_result[key] = summary.answer_text
      end
    end
    brief_result
  end

  class << self
    def prepare_history(history, dates_range)
      history_data = {}
      history.each do |k, amt|
        date = DateTime.new(k[0], k[1]).strftime('%b’ %y')
        history_data[date] = amt
      end

      dates_range.map { |date| history_data.key?(date) ? history_data[date] : 0 }
    end

    def create_xls(export_type, user, startups)
      case export_type
        when 'all'
          @startups = self.all_startups(user).includes(:tags, :founders)
        when 'manual'
          @startups = self.evolution(user).includes(:tags, :founders)
        when 'submission'
          @startups = self.founder(user).includes(:tags, :founders)
        when 'founder_evolution'
          @startups = self.founder_evolution(user).includes(:tags, :founders)
        when 'founder_brand'
          @startups = self.founder_brand(user).includes(:tags, :founders)
        when 'evo_generated'
          @startups = self.evo_generated(user).includes(:tags, :founders)
        when 'watchlist'
          @startups = self.watchlist(user).includes(:tags, :founders)
        else
          @startups = self.query_startups(startups).includes(:tags, :founders)
      end
      Export::Xls.create_startups_xls(@startups, user)
    end
  end

  def save_tmp_pdf_documents!
    pdf_documents.only_tmp.each { |d| d.update(is_tmp: false) }
  end

  def destroy_tmp_pdf_documents!
    pdf_documents.only_tmp.with_deleted.each { |d| d.really_destroy! }
  end

  private
  def strip_whitespace
    self.twitter = self.twitter.strip unless self.twitter.nil?
    self.location = self.location.strip unless self.location.nil?
    self.elevator_pitch = self.elevator_pitch.strip unless self.elevator_pitch.nil?
  end

  def rebuild_indexes
    # `rake ts:index`
    IndexWorker.perform_async
  end
end
