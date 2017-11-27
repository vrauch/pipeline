class AddColumnIsOtherToCategoryValues < ActiveRecord::Migration
  def change
    add_column :category_values, :is_other, :boolean, default: 0, after: :content
  end
end
