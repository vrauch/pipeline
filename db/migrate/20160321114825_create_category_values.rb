class CreateCategoryValues < ActiveRecord::Migration
  def change
    create_table :category_values do |t|
      t.integer :category_id
      t.string :content

      t.timestamps null: false
    end
  end
end
