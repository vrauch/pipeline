class ChangeSTypeToStartupType < ActiveRecord::Migration
  def change
    rename_column :startups, :s_type, :startup_type
  end
end
