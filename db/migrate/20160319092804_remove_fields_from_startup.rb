class RemoveFieldsFromStartup < ActiveRecord::Migration
  def change
    remove_column :startups, :funding_lifestage, :string
    remove_column :startups, :competitors, :string
    remove_column :startups, :difference, :string
    remove_column :startups, :founders, :string
    remove_column :startups, :tech_lifestage, :string
  end
end
