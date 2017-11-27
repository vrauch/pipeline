class AddIndexStartupsCreatedAt < ActiveRecord::Migration
  def change
    add_index :startups, :created_at
  end
end
