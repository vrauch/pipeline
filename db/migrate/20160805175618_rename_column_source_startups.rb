class RenameColumnSourceStartups < ActiveRecord::Migration
  def change
    rename_column :startups, :source, :connection_source
  end
end
