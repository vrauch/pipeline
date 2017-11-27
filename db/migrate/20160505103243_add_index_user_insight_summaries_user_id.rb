class AddIndexUserInsightSummariesUserId < ActiveRecord::Migration
  def change
    add_index :user_insight_summaries, :user_id
  end
end
