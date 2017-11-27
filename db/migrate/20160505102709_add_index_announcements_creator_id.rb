class AddIndexAnnouncementsCreatorId < ActiveRecord::Migration
  def change
    add_index :announcements, :creator_id
  end
end
