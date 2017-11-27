class PromoPageQuestion < ActiveRecord::Base

  TYPES = [[:single, 'Single select'], [:multi, 'Multi select'], [:text, 'Text field']]

  ANSWER_TYPE = %w[ single multi text ]

  attr_accessor :first_init
  attr_accessor :question_data_id

  enum answer_type: [:single, :multi, :text]

  belongs_to :promo_page, unscoped: true
  has_many :promo_page_question_answers, dependent: :destroy

  validates :question_text, presence: true

  accepts_nested_attributes_for :promo_page_question_answers, allow_destroy: true

  delegate :name, to: :promo_page, prefix: true
end
