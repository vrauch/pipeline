class CreateUserDiagnosticAnswers < ActiveRecord::Migration
  def change
    create_table :user_diagnostic_answers do |t|
      t.references :user
      t.integer :answer_id

      t.timestamps null: false
    end
  end
end
