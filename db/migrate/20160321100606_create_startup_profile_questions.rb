class CreateStartupProfileQuestions < ActiveRecord::Migration
  def change
    create_table :startup_profile_questions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :startup, index: true, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps null: false
    end
  end
end
