class AddPriorityToLists < ActiveRecord::Migration
  def change
    add_column :lists, :priority, :integer
  end
end
