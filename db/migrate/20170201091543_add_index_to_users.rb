class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :confirmed_at
  end
end
