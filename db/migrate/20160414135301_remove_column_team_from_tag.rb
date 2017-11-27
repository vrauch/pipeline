class RemoveColumnTeamFromTag < ActiveRecord::Migration
  def change
    remove_column :tags, :team
  end
end
