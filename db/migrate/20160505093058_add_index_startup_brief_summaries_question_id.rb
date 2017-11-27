class AddIndexStartupBriefSummariesQuestionId < ActiveRecord::Migration
  def change
    add_index :startup_brief_summaries, :question_id
  end
end
