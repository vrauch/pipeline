class StartupBriefSummary < ActiveRecord::Base
  UNIQUE_SINGLE_SELECTORS = %w(development_stage funding_stage)
  UNIQUE_MULTI_SELECTORS = %w(brand_collaboration roadmap)
  TEXT_LENGTH = 65000
  SMALL_TEXT_LENGTH = 255

  belongs_to :startup
  belongs_to :brief_question, class_name: 'StartupBriefQuestion',
                              foreign_key: :question_id
  belongs_to :brief_answer, class_name: 'StartupBriefAnswer',
                              foreign_key: :answer_id
  belongs_to :promo_question, class_name: 'PromoPageQuestion',
                              foreign_key: :question_id, unscoped: true
  belongs_to :promo_answer,   class_name: 'PromoPageQuestionAnswer',
                              foreign_key: :answer_id
  belongs_to :brand_question, class_name: 'BrandQuestion',
                              foreign_key: :question_id, unscoped: true
  belongs_to :brand_answer,   class_name: 'BrandQuestionAnswer',
                              foreign_key: :answer_id
  belongs_to :verticals,
    -> { where "`startup_brief_questions`.`alias` = 'verticals'" },
    class_name: 'StartupBriefQuestion', foreign_key: :question_id
  belongs_to :startup_brand_brief
  belongs_to :startup_promo_brief

  before_save :delete_answers_if_exists

  validates :answer_id, presence: true, if: :question_text?

  scope :main_brief, -> { where(startup_promo_brief_id: nil,
                                startup_brand_brief_id: nil) }
  scope :promo_brief, -> { where.not(startup_promo_brief_id: nil)
                           .where(startup_brand_brief_id: nil) }
  # Method for saving startups answers for questions from the setup-profile stage
  def save_answers(params)
    answers = []
    params.each do |question_id, answer|
      brief_question = StartupBriefQuestion.find_by(id: question_id)
      if brief_question.single? 
        answers << StartupBriefSummary.new(question_id: brief_question.id,
                                           answer_id: answer,
                                           startup_id: self.startup_id)
      elsif brief_question.multi? && !brief_question.detail
        answer.each do |answer_id|
          answers << StartupBriefSummary.new(question_id: brief_question.id,
                                             answer_id: answer_id,
                                             startup_id: self.startup_id)
        end
      elsif brief_question.multi? && brief_question.detail
        answer[:answer_ids].try(:each) do |answer_id|
          answers << StartupBriefSummary.new(question_id: brief_question.id,
                                             answer_id: answer_id,
                                             detail_text: answer[:detail].first(TEXT_LENGTH),
                                             startup_id: self.startup_id)
        end
      else
        answers << StartupBriefSummary.new(question_id: brief_question.id,
                                           answer_text: answer.first(TEXT_LENGTH),
                                           startup_id: self.startup_id)
      end 
    end
    answers.each { |a| a.run_callbacks(:save) { false } }
    StartupBriefSummary.import answers   
  end

  def self.save_answers(startup, brief_params)
    answers = []
    question_types = StartupBriefQuestion.types
    brief_params.each do |question_id, answer|
      if question_types[question_id.to_i].single?
        if question_types[question_id.to_i].detail?
          answer_id, answer_detail = answer['answer'], answer['detail']
        else
          answer_id, answer_detail = answer, ''
        end
        answers << StartupBriefSummary.new(
          question_id: question_id,
          answer_id: answer_id,
          detail_text: answer_detail.first(TEXT_LENGTH),
          startup_id: startup.id)
      elsif question_types[question_id.to_i].multi?
        if question_types[question_id.to_i].detail?
          answer_ids, answer_detail = answer['answers'], answer['detail']
        else
          answer_ids, answer_detail = answer, ''
        end
        next unless answer_ids
        answer_ids.each do |answer_id|
          answers << StartupBriefSummary.new(
            question_id: question_id,
            answer_id: answer_id,
            detail_text: answer_detail.first(TEXT_LENGTH),
            startup_id: startup.id)
        end
      else
        answers << StartupBriefSummary.new(
          question_id: question_id,
          answer_text: answer.first(TEXT_LENGTH),
          startup_id: startup.id)
      end
    end
    StartupBriefSummary.import answers
  end

  def self.update_answers(startup, brief_params)
    startup.startup_brief_summaries.destroy_all
    save_answers(startup, brief_params)
  end

  def save_promo_answers(params)
    answers = []
    params.each do |promo_page_id, answers_hash|
      startup_promo_brief_id = StartupPromoBrief.select(:id).find_by(startup_id: self.startup_id,
                                                          promo_page_id: promo_page_id).id
      answers_hash.each do |question_id, answer|
        brief_question = PromoPageQuestion.find_by(id: question_id,
                                                   promo_page_id: promo_page_id)
        if brief_question.single?
          answers << StartupBriefSummary.new(question_id: brief_question.id,
                                             answer_id: answer,
                                             startup_id: self.startup_id,
                                             startup_promo_brief_id: startup_promo_brief_id)
        elsif brief_question.multi?
          answer.each do |answer_id|
            answers << StartupBriefSummary.new(question_id: brief_question.id,
                                               answer_id: answer_id,
                                               startup_id: self.startup_id,
                                               startup_promo_brief_id: startup_promo_brief_id)
          end
        else
          answers << StartupBriefSummary.new(question_id: brief_question.id,
                                             answer_text: answer.first(SMALL_TEXT_LENGTH),
                                             startup_id: self.startup_id,
                                             startup_promo_brief_id: startup_promo_brief_id)
        end 
      end
    end
    answers.each { |a| a.run_callbacks(:save) { false } }
    StartupBriefSummary.import answers
  end

  def save_brand_answers(params, startup_brand_brief_id)
    answers = []
    params.each do |question_id, answer|
      brief_question = BrandQuestion.find_by(id: question_id)
      if brief_question.single?
        answers << StartupBriefSummary.new(question_id: brief_question.id,
                                           answer_id: answer,
                                           startup_id: self.startup_id,
                                           startup_brand_brief_id: startup_brand_brief_id)
      elsif brief_question.multi?
        answer.each do |answer_id|
          answers << StartupBriefSummary.new(question_id: brief_question.id,
                                             answer_id: answer_id,
                                             startup_id: self.startup_id,
                                             startup_brand_brief_id: startup_brand_brief_id)
        end
      else
        answers << StartupBriefSummary.new(question_id: brief_question.id,
                                           answer_text: answer.first(SMALL_TEXT_LENGTH),
                                           startup_id: self.startup_id,
                                           startup_brand_brief_id: startup_brand_brief_id)
      end 
    end
    answers.each { |a| a.run_callbacks(:save) { false } }
    StartupBriefSummary.import answers
  end

  class << self
    def prepare_value(value)
      return 'none specified' if value.nil? || value == ''
      value.instance_of?(Array) ? value.join(', ') : value
    end

    def brief_values(startup_brief)
      summary = {}
      startup_brief.includes(:brief_answer, :brief_question,
                             brief_answer: :category_value).each do |brief|
        category = brief.brief_question.alias.humanize.titleize
        unless brief.brief_answer
          summary[brief[:question_id]] = {
              category: category,
              value: brief.answer_text
          }
        else
          content = brief.brief_answer.category_value.content
          if brief.brief_question.single?
            summary[brief[:question_id]] = {
                category: category,
                value: content,
                has_detail: brief.brief_question.detail?,
                detail_text: brief.detail_text
            }
          else
            if summary.key?(brief[:question_id])
              summary[brief[:question_id]][:value] << content
            else
              summary[brief[:question_id]] = {
                  category: category,
                  value:  [content],
                  has_detail: brief.brief_question.detail?,
                  detail_text: brief.detail_text
              }
            end
          end
        end
      end
      summary
    end
  end

  protected

  def delete_answers_if_exists
    previous_answers = StartupBriefSummary.where(startup_promo_brief_id: self.startup_promo_brief_id, 
                                                startup_brand_brief_id: self.startup_brand_brief_id, 
                                                question_id: self.question_id, 
                                                startup_id: self.startup_id)
    previous_answers.delete_all if previous_answers.any?
  end

  def question_text?
    if self.startup_promo_brief_id.present?
      PromoPageQuestion.where(promo_page_id: startup_promo_brief.promo_page_id).find_by(id: question_id).answer_type ==
        PromoPageQuestion::answer_types[:text]
    elsif self.startup_brand_brief_id.present?
      BrandQuestion.where(brand_id: startup_brand_brief.brand_id).find_by(id: question_id).answer_type ==
        BrandQuestion::answer_types[:text]
    else
      StartupBriefQuestion.find_by(id: question_id).question_type == 
        StartupBriefQuestion::question_types[:text]
    end
  end
end
