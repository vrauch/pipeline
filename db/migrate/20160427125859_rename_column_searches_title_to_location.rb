class RenameColumnSearchesTitleToLocation < ActiveRecord::Migration
  def change
    rename_column :searches, :title, :location
  end
end
