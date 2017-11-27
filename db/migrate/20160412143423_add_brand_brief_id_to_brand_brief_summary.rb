class AddBrandBriefIdToBrandBriefSummary < ActiveRecord::Migration
  def change
    add_column :brand_brief_summaries, :brand_brief_id, :integer, after: :id
  end
end
