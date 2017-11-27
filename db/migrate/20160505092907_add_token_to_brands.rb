class AddTokenToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :token, :string, after: :brand_startups_count
  end
end
