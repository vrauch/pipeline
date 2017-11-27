class CreateStartupProfileAnswers < ActiveRecord::Migration
  def change
    create_table :startup_profile_answers do |t|
      t.references :startup_profile_question, index: true, foreign_key: true
      t.text :body

      t.timestamps null: false
    end
  end
end
