class AddIndexBrandsPackageId < ActiveRecord::Migration
  def change
    add_index :brands, :package_id
  end
end
