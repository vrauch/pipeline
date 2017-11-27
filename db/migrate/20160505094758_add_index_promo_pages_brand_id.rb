class AddIndexPromoPagesBrandId < ActiveRecord::Migration
  def change
    add_index :promo_pages, :brand_id
  end
end
