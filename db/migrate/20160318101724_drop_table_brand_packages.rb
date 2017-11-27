class DropTableBrandPackages < ActiveRecord::Migration
  def change
    drop_table :brand_packages
  end
end
