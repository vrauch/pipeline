class StartupBriefQuestionDecorator < Draper::Decorator
  delegate_all


  def checked?(answer, label = false)
    if detail?
      answers = field_value && (single? ? field_value['answer'] : field_value['answers'])
    else
      answers = field_value
    end
    return '' unless answers
    if single?
      answers.to_i == answer.id.to_i ? checked_result(label) : ''
    else
      answers.include?(answer.id.to_s) ? checked_result(label) : ''
    end
  end

  def field_value
    h.brief_params[id.to_s]
  end

  def detail_value
    field_value && field_value['detail']
  end

  private

  def checked_result(label)
    label ? 'active' : true
  end

end
