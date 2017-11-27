class AddColumnBrandStartupsCountToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :brand_startups_count, :integer, default: 0, after: :brand_users_count
    Brand.reset_column_information
    Brand.all.each do |p|
      Brand.update_counters p.id, :brand_startups_count => p.brand_startups.length
    end
  end
end
