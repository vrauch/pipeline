class AddScoresToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :product_total_score, :decimal, default: 0
    add_column :scorecards, :collaboration_total_score, :decimal, default: 0
    add_column :scorecards, :business_total_score, :decimal, default: 0
  end
end
