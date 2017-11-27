class RemoveInviteByInStartups < ActiveRecord::Migration
  def change
    remove_column :startups, :invite_by
  end
end
