class AddIndexAnnouncementsSendTo < ActiveRecord::Migration
  def change
    add_index :announcements, :send_to
  end
end
