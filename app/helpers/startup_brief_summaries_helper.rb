module StartupBriefSummariesHelper
  SORTABLE_QUESTIONS = %w[accelerator_program verticals target_audience tech_sectors].freeze
  NONE_SORTABLE_VARIANTS = %w[other n/a].freeze

  def sort_answers(answers)
    answers.sort_by do |a|
      if NONE_SORTABLE_VARIANTS.include?(a.category_value.content.try(:downcase))
        'zzzz'
      else
        a.category_value.content
      end
    end
  end

  def brief_question_answers(brief_question)
    if SORTABLE_QUESTIONS.include?(brief_question.alias)
      sort_answers(brief_question.answers)
    else
      brief_question.answers
    end
  end
end
