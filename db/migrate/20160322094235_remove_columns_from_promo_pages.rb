class RemoveColumnsFromPromoPages < ActiveRecord::Migration
  def change
    remove_column :promo_pages, :inspire_image
    remove_column :promo_pages, :inspire_video
    remove_column :promo_pages, :inspire_title
    remove_column :promo_pages, :inspire_description
  end
end
