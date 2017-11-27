class ChangeOutreachStatus < ActiveRecord::Migration
  def change
    rename_column :startups, :outsearch_status, :outreach_status
  end
end
