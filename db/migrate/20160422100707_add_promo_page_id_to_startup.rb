class AddPromoPageIdToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :promo_page_id, :integer, after: :updater_id
  end
end
