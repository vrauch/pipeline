class AddPromoBriefIdToStartupBriefSummary < ActiveRecord::Migration
  def change
    add_reference :startup_brief_summaries, :startup_promo_brief, index: true, foreign_key: true, after: :startup_brand_brief_id
  end
end
