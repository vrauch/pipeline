class AddIndexNotesAssigneeId < ActiveRecord::Migration
  def change
    add_index :notes, :assignee_id
  end
end
