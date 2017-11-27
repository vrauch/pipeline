class RenameIsFavoriteInList < ActiveRecord::Migration
  def change
    rename_column :lists, :is_favorite, :favorite
  end
end
