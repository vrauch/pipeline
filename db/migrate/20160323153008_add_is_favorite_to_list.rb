class AddIsFavoriteToList < ActiveRecord::Migration
  def change
    add_column :lists, :is_favorite, :boolean, after: :author_id, default: false
  end
end
