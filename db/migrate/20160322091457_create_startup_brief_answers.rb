class CreateStartupBriefAnswers < ActiveRecord::Migration
  def change
    create_table :startup_brief_answers do |t|
      t.integer :brief_question_id
      t.integer :category_value_id

      t.timestamps null: false
    end
  end
end
