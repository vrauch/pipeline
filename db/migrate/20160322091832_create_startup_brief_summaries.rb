class CreateStartupBriefSummaries < ActiveRecord::Migration
  def change
    create_table :startup_brief_summaries do |t|
      t.references :startup, index: true, foreign_key: true
      t.integer :question_id
      t.integer :answer_id
      t.string :answer_text

      t.timestamps null: false
    end
  end
end
