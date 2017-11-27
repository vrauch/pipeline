class RemoveBrandTeamFromStartups < ActiveRecord::Migration
  def change
    remove_column :startups, :brand_team, :integer
  end
end
