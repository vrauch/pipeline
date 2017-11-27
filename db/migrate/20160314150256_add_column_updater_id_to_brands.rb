class AddColumnUpdaterIdToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :updator_id, :integer, after: :creator_id
  end
end
