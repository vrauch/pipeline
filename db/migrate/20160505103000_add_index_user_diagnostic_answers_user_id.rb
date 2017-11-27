class AddIndexUserDiagnosticAnswersUserId < ActiveRecord::Migration
  def change
    add_index :user_diagnostic_answers, :user_id
  end
end
