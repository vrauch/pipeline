class Variant < ActiveRecord::Base
  has_one :questions_variant
  has_one :question, through: :questions_variant
  validates :title, presence: true

  scope :totlal_score_by_ids, ->(ids) { where(id: ids).sum(:score) }
  scope :total_score, -> { sum(:score) }
  scope :product, -> do
    joins(:question).where('questions.score_type' => Question.score_types[:product])
  end
  scope :collaboration, -> do
    joins(:question).where('questions.score_type' => Question.score_types[:collaboration])
  end
  scope :business, -> do
    joins(:question).where('questions.score_type' => Question.score_types[:business])
  end
  scope :b2c, -> do
    joins(:question).where.not('questions.question_type' => Question.question_types[:b2b])
  end
  scope :b2b, -> do
    joins(:question).where.not('questions.question_type' => Question.question_types[:b2c])
  end
  scope :collaboration_from, ->(question_type) do
    joins(:question).where(questions: {
      score_type: Question.score_types[:collaboration],
      question_type: [
        Question.question_types[:any],
        Question.question_types[question_type]
      ]
    })
  end
  scope :business_from, ->(question_type) do
    joins(:question).where(questions: {
      score_type: Question.score_types[:business],
      question_type: [
        Question.question_types[:any],
        Question.question_types[question_type]
      ]
    })
  end
  scope :product_from, ->(question_type) do
    joins(:question).where(questions: {
      score_type: Question.score_types[:product],
      question_type: [
        Question.question_types[:any],
        Question.question_types[question_type]
      ]
    })
  end
  scope :get_by_types, ->(score_type, question_type) do
    joins(:question).where(questions: {
      score_type: Question.score_types[score_type],
      question_type: [
        Question.question_types[:any],
        Question.question_types[question_type]
      ]
    })
  end

  scope :order_by_question_ids, ->(question_ids) do
    if question_ids.try(:any?)
      joins(:question).order("field(questions.id, #{question_ids.join(', ')})")
    end
  end
end
