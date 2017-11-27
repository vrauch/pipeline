class AddDetailToStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :detail, :boolean, after: :question_order, default: 0
  end
end
