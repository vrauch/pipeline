class AddIndexBrandBriefAnswersBrandQuestionId < ActiveRecord::Migration
  def change
    add_index :brand_brief_answers, :brief_question_id
  end
end
