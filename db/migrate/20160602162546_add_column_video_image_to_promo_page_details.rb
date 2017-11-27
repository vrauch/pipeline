class AddColumnVideoImageToPromoPageDetails < ActiveRecord::Migration
  def change
    add_column :promo_page_details, :image_video, :string, after: :inspire_video
  end
end
