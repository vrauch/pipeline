class PromoPageQuestionAnswer < ActiveRecord::Base
  belongs_to :promo_page_question

  validates :answer_text, :presence => true
end
