class AddUpdatesToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :updates, :boolean, after: :startup_pattern, default: 0
  end
end
