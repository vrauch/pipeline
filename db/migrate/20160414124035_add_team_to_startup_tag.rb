class AddTeamToStartupTag < ActiveRecord::Migration
  def change
    add_column :startup_tags, :team, :integer, after: :tag_id
  end
end
