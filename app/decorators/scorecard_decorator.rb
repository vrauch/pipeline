class ScorecardDecorator < Draper::Decorator
  delegate_all

  # fv - for view
  # for example
  # def description_fv
  #   description || unspecified
  # end

  def method_missing(name, *args, &block)
    if name =~ /^([a-z]|\_)+fv$/ && respond_to?(name.to_s.sub(/_fv$/, ''))
      value = try(name.to_s.sub(/_fv$/, ''))
      value && value != '' ? value : unspecified
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name =~ /^([a-z]|\_)+fv$/ || super
  end

  def any_scores?
    scorecard_answers.any? ? true : false
    # if product_total_score > 0 || collaboration_total_score > 0 ||
    #   business_total_score > 0
    #   true
    # else
    #   false
    # end
  end

  def recommendation_title
    if pc_score.between?(20, 25) && b_score.between?(8, 10)
      'NO BRAINER'
    elsif (pc_score.between?(15, 20) && b_score.between?(5.5, 10)) ||
          (pc_score.between?(20, 25) && b_score.between?(5.5, 7))
      'EXPLORE NOW'
    elsif (pc_score.between?(10, 14.99) && b_score.between?(5.5, 10))
      'TRACK STARTUP DEVELOPMENT PROGRESS'
    elsif (pc_score.between?(15, 25) && b_score.between?(3.5, 5.49))
      'TRACK ROADMAP AND BUSINESS NEEDS'
    else
      'PASS'
    end
  end

  private

  def unspecified
    h.content_tag :span, 'none specified', class: 'some-transparency'
  end
end
