class AddCreatorIdToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :creator_id, :integer, after: :owner_id
  end
end
