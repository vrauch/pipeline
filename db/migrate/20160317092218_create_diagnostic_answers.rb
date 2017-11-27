class CreateDiagnosticAnswers < ActiveRecord::Migration
  def change
    create_table :diagnostic_answers do |t|
      t.string :question_id
      t.string :answer_text
      t.integer :number_points
      t.timestamps null: false
    end
  end
end
