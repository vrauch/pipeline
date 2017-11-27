class AddIndexStartupsCreatorId < ActiveRecord::Migration
  def change
    add_index :startups, :creator_id
  end
end
