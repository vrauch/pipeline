class CreateBrandBriefs < ActiveRecord::Migration
  def change
    create_table :brand_briefs do |t|
      t.references :brand, index: true, foreign_key: true
      t.integer :submitter_id

      t.timestamps null: false
    end
  end
end
