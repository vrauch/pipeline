class AddIndexBrandBriefSummariesAnswerId < ActiveRecord::Migration
  def change
    add_index :brand_brief_summaries, :answer_id
  end
end
