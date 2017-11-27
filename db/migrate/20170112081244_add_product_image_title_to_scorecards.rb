class AddProductImageTitleToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :product_image_title, :string
  end
end
