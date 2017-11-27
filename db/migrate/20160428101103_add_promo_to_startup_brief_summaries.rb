class AddPromoToStartupBriefSummaries < ActiveRecord::Migration
  def change
    add_column :startup_brief_summaries, :promo, :boolean, after: :detail_text, default: 0
  end
end
