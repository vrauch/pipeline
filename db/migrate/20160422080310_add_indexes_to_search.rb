class AddIndexesToSearch < ActiveRecord::Migration
  def change
    add_index :searches, :user_id
    add_index :search_categories, :search_id
    add_index :search_categories, :category_value_id
  end
end
