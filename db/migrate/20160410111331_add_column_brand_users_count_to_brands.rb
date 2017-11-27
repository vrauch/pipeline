class AddColumnBrandUsersCountToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :brand_users_count, :integer, default: 0, after: :package_id
    Brand.reset_column_information
    Brand.all.each do |p|
      Brand.update_counters p.id, :brand_users_count => p.brand_users.length
    end
  end
end
