class RemoveColumnBrandFromBrandBriefSummary < ActiveRecord::Migration
  def change
    remove_column :brand_brief_summaries, :brand_id
  end
end
