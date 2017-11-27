class BrandBriefSummary < ActiveRecord::Base

  belongs_to :brand_brief
  belongs_to :brief_question, class_name: 'BrandBriefQuestion', foreign_key: :question_id
  belongs_to :brief_answer, class_name: 'BrandBriefAnswer',  foreign_key: :answer_id

  def save_answers(brief_params)
    answers = []
    brief_params.each do |question_id, answer|
      if answer[:answer_text]
        answers << self.class.new(question_id: question_id,
                                  answer_text: answer[:answer_text],
                                  brand_brief_id: brand_brief.id)
      elsif answer[:answer_id].instance_of? Array
        answer[:answer_id].each do |answer_id|
          answers << self.class.new(question_id: question_id,
                                    answer_id: answer_id,
                                    brand_brief_id: brand_brief.id)
        end
      else
        answers << self.class.new(question_id: question_id,
                                  answer_id: answer[:answer_id],
                                  brand_brief_id: brand_brief.id)
      end

    end
    self.class.where(brand_brief_id: brand_brief.id).delete_all if self.persisted?
    self.class.import answers
  end
end
