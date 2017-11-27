class AddBrandCounterFieldToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :brand_tags_count, :integer, default: 0, after: :evo_tags_count
  end
end
