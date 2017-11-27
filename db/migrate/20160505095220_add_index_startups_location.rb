class AddIndexStartupsLocation < ActiveRecord::Migration
  def change
    add_index :startups, :location
  end
end
