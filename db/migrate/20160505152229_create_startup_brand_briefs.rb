class CreateStartupBrandBriefs < ActiveRecord::Migration
  def change
    create_table :startup_brand_briefs do |t|
      t.references :startup, index: true, foreign_key: true
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
