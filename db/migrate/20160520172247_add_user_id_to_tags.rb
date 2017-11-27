class AddUserIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :user_id, :integer, after: :alias
    Tag.update_all(user_id: 1)
  end
end
