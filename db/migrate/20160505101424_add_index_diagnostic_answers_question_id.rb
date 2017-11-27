class AddIndexDiagnosticAnswersQuestionId < ActiveRecord::Migration
  def change
    add_index :diagnostic_answers, :question_id
  end
end
