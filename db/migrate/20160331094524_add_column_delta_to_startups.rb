class AddColumnDeltaToStartups < ActiveRecord::Migration
  def change
    add_column :startups, :delta, :boolean, default: true, null: false, after: :owner_id
    add_column :startup_tags, :delta, :boolean, default: true, null: false, after: :tag_id
    add_column :tags, :delta, :boolean, default: true, null: false, after: :title
  end
end
