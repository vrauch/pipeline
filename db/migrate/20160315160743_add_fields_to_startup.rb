class AddFieldsToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :founders, :string, after: :s_type
    add_column :startups, :video_url, :string, after: :founders
    add_column :startups, :source, :string, after: :video_url
    add_column :startups, :outsearch_status, :string, after: :source
  end
end
