class AddUniqueIndexToStartupTags < ActiveRecord::Migration
  def change
    add_index :startup_tags, [:startup_id, :tag_id], unique: true
  end
end
