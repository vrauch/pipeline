class AddColumnLogoToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :logo, :string, :limit => 255, after: :id
  end
end
