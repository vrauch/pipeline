class AddTokenToPromoPages < ActiveRecord::Migration
  def change
    add_column :promo_pages, :token, :string, limit: 255, after: :updater_id
  end
end
