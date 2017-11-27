class AddIndexNotesAuthorId < ActiveRecord::Migration
  def change
    add_index :notes, :author_id
  end
end
