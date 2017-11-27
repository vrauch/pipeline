class AddIndexBrandsUpdatorId < ActiveRecord::Migration
  def change
    add_index :brands, :updator_id
  end
end
