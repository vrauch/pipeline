class CreatePromoPages < ActiveRecord::Migration
  def change
    create_table :promo_pages do |t|
      t.integer :brand_id
      t.string :cover_image, limit: 255
      t.string :name, limit: 255
      t.string :intro_message, limit: 255
      t.string :brand_color, limit: 255
      t.string :description, limit: 1000

      t.string :inspire_image, limit: 255
      t.string :inspire_video, limit: 255
      t.string :inspire_title, limit: 255
      t.string :inspire_description, limit: 1000

      t.string :form_image, limit: 255
      t.string :form_title, limit: 255
      t.string :form_copy, limit: 255

      t.string :website, limit: 255
      t.integer :promo_page_status, limit: 3, default: 0
      t.boolean :is_draft
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps null: false
    end
  end
end
