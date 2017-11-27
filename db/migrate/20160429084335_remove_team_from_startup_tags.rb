class RemoveTeamFromStartupTags < ActiveRecord::Migration
  def change
    remove_column :startup_tags, :team, :integer
  end
end
