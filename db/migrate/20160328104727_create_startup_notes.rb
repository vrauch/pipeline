class CreateStartupNotes < ActiveRecord::Migration
  def change
    create_table :startup_notes do |t|
      t.references :startup, index: true, foreign_key: true
      t.references :note, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
