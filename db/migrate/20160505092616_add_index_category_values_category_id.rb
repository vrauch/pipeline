class AddIndexCategoryValuesCategoryId < ActiveRecord::Migration
  def change
    add_index :category_values, :category_id
  end
end
