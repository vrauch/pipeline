class AddAliasToTag < ActiveRecord::Migration
  def change
    add_column :tags, :alias, :string, after: :title
  end
end
