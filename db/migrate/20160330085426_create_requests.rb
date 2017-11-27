class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :startup_id
      t.references :brand, index: true, foreign_key: true
      t.integer :author_id
      t.integer :request_type
      t.text :body

      t.timestamps null: false
    end
  end
end
