class AddUpdaterIdToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :updater_id, :integer, after: :creator_id
  end
end
