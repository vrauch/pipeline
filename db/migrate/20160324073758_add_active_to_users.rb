class AddActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :integer, default: 0, after: :last_sign_in_ip
  end
end
