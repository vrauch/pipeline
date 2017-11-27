class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :author_id
      t.index :author_id

      t.timestamps null: false
    end
  end
end
