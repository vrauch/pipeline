class AddDeletedAtToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :deleted_at, :datetime, index: true
  end
end
