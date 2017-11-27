class RenameBrandIdInStartupBriefSummary < ActiveRecord::Migration
  def change
    rename_column :startup_brief_summaries, :brand_id, :startup_brand_brief_id
  end
end
