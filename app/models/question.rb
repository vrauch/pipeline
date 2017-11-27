class Question < ActiveRecord::Base
  has_many :questions_variants, dependent: :destroy
  has_many :variants, through: :questions_variants
  has_one :scorecard_templates_question, inverse_of: :question, dependent: :destroy
  has_one :scorecard_template, through: :scorecard_templates_question

  # accepts_nested_attributes_for :questions_variants
  accepts_nested_attributes_for :variants

  enum question_type: %i[ any b2b b2c ]
  enum score_type: %i[ product collaboration business ]
  enum question_for: %i[ scorecards ]
  validates :body, presence: true

  attr_accessor :is_selected

  scope :default, -> { where(is_default: true) }
  scope :custom, -> { where(is_default: false) }
  # scope :product_b2b, -> { product.where.not(question_type: question_types[:b2c]) }
  # scope :product_b2c, -> { product.where.not(question_type: question_types[:b2b]) }
  # scope :collaboration_b2b, -> { collaboration.where.not(question_type: question_types[:b2c]) }
  # scope :collaboration_b2c, -> { collaboration.where.not(question_type: question_types[:b2b]) }
  # scope :business_b2b, -> { business.where.not(question_type: question_types[:b2c]) }
  # scope :business_b2c, -> { business.where.not(question_type: question_types[:b2b]) }
  scope :from_product, ->(question_type) do
    product.where(question_type: [question_types[:any], question_types[question_type]])
  end
  scope :from_collaboration, ->(question_type) do
    collaboration.where(question_type: [question_types[:any], question_types[question_type]])
  end
  scope :from_business, ->(question_type) do
    business.where(question_type: [question_types[:any], question_types[question_type]])
  end
end
