class AddSuperOnlyToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :super_only, :boolean, default: 0, after: :updates
  end
end
