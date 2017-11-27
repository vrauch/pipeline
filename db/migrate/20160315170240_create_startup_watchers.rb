class CreateStartupWatchers < ActiveRecord::Migration
  def change
    create_table :startup_watchers do |t|
      t.integer :startup_id
      t.integer :watcher_id

      t.timestamps null: false
    end
    add_index :startup_watchers, :startup_id
    add_index :startup_watchers, :watcher_id
  end
end
