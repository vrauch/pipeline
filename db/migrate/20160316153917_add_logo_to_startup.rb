class AddLogoToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :logo, :string, after: :title
  end
end
