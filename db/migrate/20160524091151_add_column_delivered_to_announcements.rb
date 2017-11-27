class AddColumnDeliveredToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :delivered, :boolean, after: :creator_id
  end
end
