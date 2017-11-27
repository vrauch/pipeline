class RenameColumnInDiagnosticQuestions < ActiveRecord::Migration
  def change
    rename_column :diagnostic_questions, :question, :question_text
  end
end
