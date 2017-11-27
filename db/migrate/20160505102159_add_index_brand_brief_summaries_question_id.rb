class AddIndexBrandBriefSummariesQuestionId < ActiveRecord::Migration
  def change
    add_index :brand_brief_summaries, :question_id
  end
end
