class AddIndexAnnouncementUserAnnouncementId < ActiveRecord::Migration
  def change
    add_index :announcement_users, :announcement_id
  end
end
