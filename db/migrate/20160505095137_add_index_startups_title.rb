class AddIndexStartupsTitle < ActiveRecord::Migration
  def change
    add_index :startups, :title
  end
end
