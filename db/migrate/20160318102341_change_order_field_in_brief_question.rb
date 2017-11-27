class ChangeOrderFieldInBriefQuestion < ActiveRecord::Migration
  def change
    rename_column :brief_questions, :order, :question_order
  end
end
