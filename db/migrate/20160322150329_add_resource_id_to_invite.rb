class AddResourceIdToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :resource_id, :integer, after: :role
  end
end
