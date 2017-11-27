class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_token_id, :string, after: :reset_password_sent_at
  end

end
