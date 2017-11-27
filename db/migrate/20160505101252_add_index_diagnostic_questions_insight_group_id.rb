class AddIndexDiagnosticQuestionsInsightGroupId < ActiveRecord::Migration
  def change
    add_index :diagnostic_questions, :insight_group_id
  end
end
