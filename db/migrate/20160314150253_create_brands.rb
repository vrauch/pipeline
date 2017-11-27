class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :title, :limit => 255
      t.string :description, :limit => 1000
      t.string :site, :limit => 255
      t.string :location, :limit => 255
      t.integer :creator_id, null: false
      t.timestamps null: false
    end

    add_index :brands, :creator_id, name: 'brand_creator'
  end
end
