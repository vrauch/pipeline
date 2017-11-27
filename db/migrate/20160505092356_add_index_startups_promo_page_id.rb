class AddIndexStartupsPromoPageId < ActiveRecord::Migration
  def change
    add_index :startups, :promo_page_id
  end
end
