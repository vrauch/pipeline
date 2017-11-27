class AddIndexPromoPageDetailsPromoPageId < ActiveRecord::Migration
  def change
    add_index :promo_page_details, :promo_page_id
  end
end
