module UserDiagnosticSummariesHelper

  def insight_summaries(diagnostic_values)
    answer_ids = []
    diagnostic_values.each do |value|
      answer_ids << value[:answer_id]
    end

    diagnostic_answers = DiagnosticAnswer.where(id: answer_ids)

    insight_points = Hash.new(0)
    diagnostic_answers.each do |answer|
      insight_points[answer.question.insight_group_id] += answer.number_points
    end

    insight_summaries = []
    insight_points.each do |insight_group_id, points|
      @diagnostic_types.each do |diagnostic_type|
        if (diagnostic_type.points_from..diagnostic_type.points_to).include? points
          insight_summaries << { diagnostic_type_id: diagnostic_type.id,
                                 insight_group_id: insight_group_id}
        end
      end
    end
    insight_summaries
  end
end
