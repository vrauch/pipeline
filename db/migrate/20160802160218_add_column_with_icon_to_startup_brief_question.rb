class AddColumnWithIconToStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :with_icon, :boolean, after: :style, default: 0
  end
end
