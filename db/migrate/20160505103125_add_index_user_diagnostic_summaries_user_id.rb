class AddIndexUserDiagnosticSummariesUserId < ActiveRecord::Migration
  def change
    add_index :user_diagnostic_summaries, :user_id
  end
end
