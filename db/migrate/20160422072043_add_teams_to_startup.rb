class AddTeamsToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :evo_team, :boolean, default: 0, after: :updater_id
    add_column :startups, :brand_team, :boolean, default: 0, after: :evo_team
  end
end
