class CreateSearchCategories < ActiveRecord::Migration
  def change
    create_table :search_categories do |t|
      t.integer :search_id
      t.integer :category_value_id
      t.timestamps null: false
    end
  end
end
