class BrandQuestionAnswer < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :brand_question

  validates :answer_text, :presence => true

  #amoeba do
  #  enable
  #  customize(lambda { |original, clone|
  #    clone.promo_page_question_id = original.brand_question_id
  #  })
  #end
end
