class CreateNoteComments < ActiveRecord::Migration
  def change
    create_table :note_comments do |t|
      t.references :note, index: true, foreign_key: true
      t.integer :author_id
      t.text :body

      t.timestamps null: false
    end
  end
end
