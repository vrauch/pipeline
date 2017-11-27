class AddDeletedAtToUserActivities < ActiveRecord::Migration
  def change
    add_column :user_activities, :deleted_at, :datetime
    add_index :user_activities, :deleted_at
  end
end
