class AddIndexStartupBriefSummariesAnswerId < ActiveRecord::Migration
  def change
    add_index :startup_brief_summaries, :answer_id
  end
end
