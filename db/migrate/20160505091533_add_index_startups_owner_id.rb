class AddIndexStartupsOwnerId < ActiveRecord::Migration
  def change
    add_index :startups, :owner_id
  end
end
