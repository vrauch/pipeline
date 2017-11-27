class AddIndexBrandBriefSummariesBrandBriefId < ActiveRecord::Migration
  def change
    add_index :brand_brief_summaries, :brand_brief_id
  end
end
