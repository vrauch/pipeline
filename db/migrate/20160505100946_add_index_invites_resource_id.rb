class AddIndexInvitesResourceId < ActiveRecord::Migration
  def change
    add_index :invites, :resource_id
  end
end
