class RemoveEvoTeamFromStartups < ActiveRecord::Migration
  def change
    remove_column :startups, :evo_team, :integer
  end
end
