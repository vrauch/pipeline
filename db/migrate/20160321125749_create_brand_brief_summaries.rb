class CreateBrandBriefSummeries < ActiveRecord::Migration
  def change
    create_table :brand_brief_summaries do |t|
      t.integer :brand_id
      t.integer :question_id
      t.integer :answer_id
      t.string :answer_text

      t.timestamps null: false
    end
  end
end
