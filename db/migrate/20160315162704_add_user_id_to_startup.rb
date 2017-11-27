class AddUserIdToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :user_id, :integer, after: :outsearch_status
  end
end
