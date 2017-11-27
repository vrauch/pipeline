class AddColumnUpToToBrandBriefQuestions < ActiveRecord::Migration
  def change
    add_column :brand_brief_questions, :up_to, :integer, after: :question_order
  end
end
