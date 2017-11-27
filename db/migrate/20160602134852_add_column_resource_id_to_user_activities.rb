class AddColumnResourceIdToUserActivities < ActiveRecord::Migration
  def change
    add_column :user_activities, :resource_id, :integer, after: :startup_text
  end
end
