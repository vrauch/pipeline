class AddIndexUserInsightSummariesInsightGroupId < ActiveRecord::Migration
  def change
    add_index :user_insight_summaries, :insight_group_id
  end
end
