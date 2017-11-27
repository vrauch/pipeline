class AddIndexAnnouncementUserUserId < ActiveRecord::Migration
  def change
    add_index :announcement_users, :user_id
  end
end
