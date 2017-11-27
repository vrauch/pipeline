class AddBrandIdToStartupBriefSummary < ActiveRecord::Migration
  def change
    add_column :startup_brief_summaries, :brand_id, :integer, after: :promo
    add_index :startup_brief_summaries, :brand_id 
  end
end
