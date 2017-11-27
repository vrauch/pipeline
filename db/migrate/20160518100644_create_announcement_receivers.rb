class CreateAnnouncementReceivers < ActiveRecord::Migration
  def change
    create_table :announcement_receivers do |t|
      t.integer :announcement_id
      t.boolean :receiver_type
      t.integer :receiver_id
      t.timestamps null: false
    end

    add_index :announcement_receivers, :announcement_id
    add_index :announcement_receivers, :receiver_id
  end
end
