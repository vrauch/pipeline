class AddInsightGroupIdToDiagnosticQuestions < ActiveRecord::Migration
  def change
    add_column :diagnostic_questions, :insight_group_id, :integer, after: :question_text
  end
end
