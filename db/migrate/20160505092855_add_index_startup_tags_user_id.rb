class AddIndexStartupTagsUserId < ActiveRecord::Migration
  def change
    add_index :startup_tags, :user_id
  end
end
