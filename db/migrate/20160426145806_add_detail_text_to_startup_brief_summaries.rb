class AddDetailTextToStartupBriefSummaries < ActiveRecord::Migration
  def change
    add_column :startup_brief_summaries, :detail_text, :text, after: :answer_text
  end
end
