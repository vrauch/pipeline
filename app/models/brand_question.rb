class BrandQuestion < ActiveRecord::Base
  acts_as_paranoid

  TYPES = [[:single, 'Single select'], [:multi, 'Multi select'], [:text, 'Text field']]

  attr_accessor :first_init
  attr_accessor :question_data_id

  enum answer_type: [:single, :multi, :text]

  ANSWER_TYPE = %w[ single multi text ]

  belongs_to :brand, unscoped: true
  has_many :brand_question_answers

  validates :question_text, presence: true

  delegate :title, to: :brand, prefix: true  

  #amoeba do
  #  enable
  #  customize(lambda { |original, clone|
  #    clone.promo_page_id = original.brand_id
  #  })
  #end

  accepts_nested_attributes_for :brand_question_answers, allow_destroy: true


  # def skip_validation=(value)
  #   ap brand_question_answers
  #   brand_question_answers.skip_validation = value
  # end
end
