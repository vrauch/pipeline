class AddIconNameToCategoryValue < ActiveRecord::Migration
  def change
    add_column :category_values, :icon_name, :string, after: :content
  end
end
