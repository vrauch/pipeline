class AddIndexStartupBriefAnswersBriefQuestionId < ActiveRecord::Migration
  def change
    add_index :startup_brief_answers, :brief_question_id
  end
end
