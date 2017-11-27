class AlterTableAnnouncementUsers < ActiveRecord::Migration
  def change
    remove_column :announcement_users, :announcement_id
    add_column :announcement_users, :announcement_receiver_id, :integer, after: :id
    add_index :announcement_users, :announcement_receiver_id
  end
end
