class AddScorecardsCountToScorecardTemplates < ActiveRecord::Migration
  def change
    add_column :scorecard_templates, :scorecards_count, :integer, default: 0
  end
end
