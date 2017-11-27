class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.integer :send_to, null: false
      t.text :content
      t.string :cover
      t.string :image
      t.integer :creator_id, null: false
      t.timestamps null: false
    end
  end
end
