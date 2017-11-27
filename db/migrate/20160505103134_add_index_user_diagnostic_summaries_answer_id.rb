class AddIndexUserDiagnosticSummariesAnswerId < ActiveRecord::Migration
  def change
    add_index :user_diagnostic_summaries, :answer_id
  end
end
