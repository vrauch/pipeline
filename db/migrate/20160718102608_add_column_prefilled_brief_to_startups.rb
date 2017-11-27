class AddColumnPrefilledBriefToStartups < ActiveRecord::Migration
  def change
    add_column :startups, :prefilled_brief, :boolean, default: 0, after: :updater_id
  end
end
