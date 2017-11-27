class AddColumnResourceTypeToUserActivities < ActiveRecord::Migration
  def change
    add_column :user_activities, :resource_type, :integer, after: :resource_id
  end
end
