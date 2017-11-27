class CreatePromoPageDetails < ActiveRecord::Migration
  def change
    create_table :promo_page_details do |t|
      t.references :promo_page
      t.string :inspire_image, limit: 255
      t.string :inspire_video, limit: 255
      t.string :inspire_title, limit: 255
      t.string :inspire_description, limit: 1000
      t.timestamps null: false
    end
  end
end
