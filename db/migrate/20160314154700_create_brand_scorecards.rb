class CreateBrandScorecards < ActiveRecord::Migration
  def change
    create_table :brand_scorecards, :id => false do |t|
      t.references :brand
      t.references :scorecard
    end

    add_index :brand_scorecards, :brand_id, name: 'brand_scorecards'
  end
end
