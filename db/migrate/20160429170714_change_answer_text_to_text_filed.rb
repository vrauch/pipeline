class ChangeAnswerTextToTextFiled < ActiveRecord::Migration
  def change
    change_column :startup_brief_summaries, :answer_text, :text
  end
end
