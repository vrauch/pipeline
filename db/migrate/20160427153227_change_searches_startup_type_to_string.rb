class ChangeSearchesStartupTypeToString < ActiveRecord::Migration
  def change
    change_column :searches, :startup_type, :string
  end
end
