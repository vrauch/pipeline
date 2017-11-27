class CreateScorecardTemplates < ActiveRecord::Migration
  def change
    create_table :scorecard_templates do |t|
      t.string :title_brand
      t.string :title_brief
      t.string :title_year
      t.integer :scorecard_type
      t.integer :startup_model
      t.string :macro_categories_title, limit: 50
      t.string :micro_categories_title, limit: 50
      t.integer :ls_product_section_type
      t.integer :rs_product_section_type
      t.string :logo, limit: 255
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
