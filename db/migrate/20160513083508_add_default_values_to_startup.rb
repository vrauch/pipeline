class AddDefaultValuesToStartup < ActiveRecord::Migration
  def change
    change_column :startups, :share_info, :boolean, default: true
    change_column :startups, :receive_emails, :boolean, default: true
  end
end
