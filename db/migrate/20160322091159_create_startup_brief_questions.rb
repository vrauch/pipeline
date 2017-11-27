class CreateStartupBriefQuestions < ActiveRecord::Migration
  def change
    create_table :startup_brief_questions do |t|
      t.string :content
      t.string :alias
      t.integer :question_type
      t.integer :progress_step
      t.integer :question_order

      t.timestamps null: false
    end
  end
end
