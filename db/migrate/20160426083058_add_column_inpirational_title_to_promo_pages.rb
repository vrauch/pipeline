class AddColumnInpirationalTitleToPromoPages < ActiveRecord::Migration
  def change
    add_column :promo_pages, :inspirational_title, :string, after: :brand_color
  end
end
