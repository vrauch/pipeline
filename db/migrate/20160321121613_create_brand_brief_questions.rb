class CreateBrandBriefQuestions < ActiveRecord::Migration
  def change
    create_table :brand_brief_questions do |t|
      t.string :content
      t.integer :question_type
      t.integer :progress_step
      t.integer :question_order

      t.timestamps null: false
    end
  end
end
