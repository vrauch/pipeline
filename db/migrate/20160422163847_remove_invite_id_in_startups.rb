class RemoveInviteIdInStartups < ActiveRecord::Migration
  def change
    remove_column :startups, :invite_id
  end
end
