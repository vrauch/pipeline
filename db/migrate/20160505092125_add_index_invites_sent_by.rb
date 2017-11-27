class AddIndexInvitesSentBy < ActiveRecord::Migration
  def change
    add_index :invites, :sent_by
  end
end
