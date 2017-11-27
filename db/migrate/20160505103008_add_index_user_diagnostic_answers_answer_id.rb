class AddIndexUserDiagnosticAnswersAnswerId < ActiveRecord::Migration
  def change
    add_index :user_diagnostic_answers, :answer_id
  end
end
