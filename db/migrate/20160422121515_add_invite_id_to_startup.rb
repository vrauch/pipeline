class AddInviteIdToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :invite_id, :integer, after: :promo_page_id
  end
end
