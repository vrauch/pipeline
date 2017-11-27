class RemoveColumnsDeltaFromStatups < ActiveRecord::Migration
  def change
    remove_column :startups, :delta
    remove_column :startup_tags, :delta
    remove_column :tags, :delta
  end
end
