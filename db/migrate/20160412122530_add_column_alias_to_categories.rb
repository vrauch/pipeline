class AddColumnAliasToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :alias, :string, after: :name
  end
end
