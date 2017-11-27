class CreateBrandStartups < ActiveRecord::Migration
  def change
    create_table :brand_startups do |t|
      t.references :brand, index: true, foreign_key: true
      t.references :startup, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
