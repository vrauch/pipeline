class Brand < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :logo, PictureUploader

  STEPS = %w[info email questions users]

  attr_writer :current_step
  attr_accessor :previous
  attr_accessor :invite_email
  attr_accessor :invite_user_name

  has_many   :brand_packages
  has_one    :email_template
  has_many   :brand_questions
  has_one    :active_package, -> { where active: true }, class_name: 'BrandPackage'
  has_one    :package, through: :active_package, unscoped: true
  belongs_to :updator, class_name: 'User'
  has_one    :brand_point_of_contact, -> { order created_at: :asc }, class_name: 'BrandUser'
  has_one    :point_of_contact, through: :brand_point_of_contact, source: :user
  has_many   :brand_startups
  has_many   :startups, through: :brand_startups
  has_many   :scorecard_templates
  has_many   :scorecards, through: :scorecard_templates
  has_many   :pushed_startups, through: :brand_startups, source: :startup
  has_many   :brand_users
  has_many   :users, through: :brand_users
  has_many   :promo_pages, unscoped: true
  has_many   :requests
  has_many   :invites, foreign_key: :resource_id, dependent: :destroy
  has_one    :brand_brief
  has_many   :activities, -> { where resource_type: UserActivity.resource_types[:brand] },
             class_name: 'UserActivity', foreign_key: :resource_id,
             dependent: :destroy

  accepts_nested_attributes_for :email_template, reject_if: :all_blank,
                                allow_destroy: true
  accepts_nested_attributes_for :brand_questions, reject_if: :all_blank,
                                allow_destroy: true

  # validates :title, presence: true, if: :info_step?
  validates :color, length: {minimum: 4, maximum: 7}, allow_blank: true
  validates_format_of :color, with: /\A#(?:[0-9a-fA-F]{3,6})\Z/, allow_blank: true
  validates :contact_email, format: { with: Devise.email_regexp },
                                              if: :info_step?, allow_blank: true
  validates :title, :location, :package_id, :description, presence: true, if: :info_step?
  validates :description, length: {maximum: 1000}
  validates :logo, file_size: { maximum: 2.megabyte.to_i }, if: :info_step?
  validates :invite_email, presence: true,
                           format: { with: Devise.email_regexp },
                           if: :users_step?
  validates :invite_user_name, presence: true, if: :users_step?
  validate  :uniqueness_email, if: :users_step?

  before_create :brand_token
  before_create :brand_alias

  def current_step
    @current_step || STEPS.first
  end

  def next_step
    self.current_step = STEPS[STEPS.index(current_step) + 1]
  end

  def get_next_step
    STEPS[STEPS.index(current_step) + 1]
  end

  def previous_step
    self.previous = self.current_step
    self.current_step = STEPS[STEPS.index(current_step) - 1]
  end

  def get_previous_step
    STEPS[STEPS.index(current_step) - 1]
  end

  def first_step?
    self.current_step == STEPS.first
  end

  def last_step?
    self.current_step == STEPS.last
  end

  def form_brief_result
    @summary = {}
    return @summary unless brand_brief
    brand_brief.brief_summaries.includes(:brief_answer, :brief_question,
                                          brief_answer: :category_value)
                                      .each do |summary|
      q_alias = summary.brief_question.alias
      if summary.brief_answer.nil?
        @summary[q_alias] = { question: summary.brief_question.content,
                              answer: summary.answer_text }
      else
        if @summary[q_alias].nil?
          @summary[q_alias] = [{
            content: summary.brief_answer.category_value.content,
            icon_name: summary.brief_answer.category_value.icon_name
          }]
        else
          @summary[q_alias] << {
            content: summary.brief_answer.category_value.content,
            icon_name: summary.brief_answer.category_value.icon_name
          }
        end
      end
    end
    @summary
  end

  def form_answers_result
    @summary = HashWithIndifferentAccess.new
    brand_brief.brief_summaries.includes(:brief_answer, :brief_question,
                                          brief_answer: :category_value)
                               .each do |summary|
      q_alias = summary.brief_question.alias
      if summary.brief_answer.nil?
        @summary[q_alias] = summary.answer_text
      else
        if @summary[q_alias].nil?
          @summary[q_alias] = [summary.brief_answer.id]
        else
          @summary[q_alias] << summary.brief_answer.id
        end
      end
    end
    @summary
  end

  def initial
    title[0, 1] if title
  end

  def logo_dimensions
    logo.store_dimensions
  end

  protected

  def info_step?
    self.current_step == STEPS.first
  end

  def users_step?
    self.current_step == STEPS.last
  end

  def brand_token
    loop do
      @token = Devise.friendly_token
      break @token unless self.class.exists?(token: @token)
    end
    self.token = @token
  end

  def brand_alias
    i = 0
    loop do
      title_alias = self.title.gsub(/[^0-9A-Za-z]/, '_').downcase
      @title_alias = i == 0 ? title_alias : "#{title_alias}_#{i}"
      break @title_alias unless self.class.exists?(alias: @title_alias)
      i += 1
    end
    self.alias = @title_alias
  end

  def uniqueness_email
    invite = Invite.where(email: self.invite_email)
    user = User.where(email: self.invite_email)
    if invite.any? || user.any?
      errors.add(:invite_email, 'has already been taken')
    end
  end

end
