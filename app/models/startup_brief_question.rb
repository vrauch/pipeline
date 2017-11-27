class StartupBriefQuestion < ActiveRecord::Base
  enum question_type: [:single, :multi, :text]

  LAST_STEP = 4

  default_scope -> { includes(:answers) }
  has_many :answers, class_name: 'StartupBriefAnswer', foreign_key: :brief_question_id
  has_many :brief_summaries, -> { where alias: 'verticals' },
           class_name: 'StartupBriefSummary', foreign_key: :question_id
  has_many :answers, class_name: 'StartupBriefAnswer', foreign_key: :brief_question_id

  scope :step, -> (step_number) { where(progress_step: step_number) }

  class << self
    def types
      all.inject({}) do |hsh, question|
        hsh.merge(question.id => question)
      end
    end
  end

end
