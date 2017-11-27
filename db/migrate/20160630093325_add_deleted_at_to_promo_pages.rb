class AddDeletedAtToPromoPages < ActiveRecord::Migration
  def change
    add_column :promo_pages, :deleted_at, :datetime
    add_index :promo_pages, :deleted_at
  end
end
