class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :author_id
      t.text :note_text
      t.date :due_date
      t.integer :assignee_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
