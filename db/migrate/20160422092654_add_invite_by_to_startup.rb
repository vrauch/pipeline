class AddInviteByToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :invite_by, :integer, after: :updater_id
  end
end
