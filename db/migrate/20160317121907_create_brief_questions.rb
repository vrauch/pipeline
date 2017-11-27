class CreateBriefQuestions < ActiveRecord::Migration
  def change
    create_table :brief_questions do |t|
      t.integer :ownership
      t.string :question_text
      t.integer :question_type
      t.references :category, brand_questions: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
