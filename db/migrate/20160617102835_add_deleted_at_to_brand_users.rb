class AddDeletedAtToBrandUsers < ActiveRecord::Migration
  def change
    add_column :brand_users, :deleted_at, :datetime
    add_index :brand_users, :deleted_at
  end
end
