class AddIndexUserInsightSummariesDiagnosticTypeId < ActiveRecord::Migration
  def change
  end
  add_index :user_insight_summaries, :diagnostic_type_id
end
