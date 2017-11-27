class AddCheckboxFieldsToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :share_info, :boolean, after: :brand_tags_count, default: 0
    add_column :startups, :receive_emails, :boolean, after: :share_info, default: 0
  end
end
