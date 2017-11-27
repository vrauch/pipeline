class AddIndexNoteCommentsAuthorId < ActiveRecord::Migration
  def change
    add_index :note_comments, :author_id
  end
end
