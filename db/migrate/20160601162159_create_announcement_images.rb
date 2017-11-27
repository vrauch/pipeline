class CreateAnnouncementImages < ActiveRecord::Migration
  def change
    create_table :announcement_images do |t|
      t.integer :announcement_id
      t.string :image
      t.timestamps null: false
    end

    add_index :announcement_images, :announcement_id
  end
end
