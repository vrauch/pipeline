class CreateScorecards < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.integer :scorecard_template_id, index: true
      t.integer :startup_id, index: true
      t.string :title
      t.string :website
      t.string :dev_stage
      t.string :fun_stage
      t.string :macro_trends
      t.string :micro_trends
      t.string :brand_experience
      t.text :description
      t.text :problem_startup_solves
      t.text :how_it_works
      t.string :logo
      t.string :product_image
      t.text :recommendation
      t.integer :state
      t.date :date_founded
      t.string :location

      t.timestamps null: false
    end
  end
end
