class AddRsProductImageToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :rs_product_image, :string
    add_column :scorecards, :rs_product_image_title, :string
  end
end
