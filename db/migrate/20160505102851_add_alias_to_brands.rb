class AddAliasToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :alias, :string, after: :title
  end
end
