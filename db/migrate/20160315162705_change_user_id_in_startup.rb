class ChangeUserIdInStartup < ActiveRecord::Migration
  def change
    rename_column :startups, :user_id, :owner_id
  end
end
