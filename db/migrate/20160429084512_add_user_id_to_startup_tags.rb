class AddUserIdToStartupTags < ActiveRecord::Migration
  def change
    add_column :startup_tags, :user_id, :integer, after: :tag_id
  end
end
