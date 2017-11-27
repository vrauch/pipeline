class AddColumnWrapIconStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :wrap_icon, :boolean, after: :money_field, default: 0
  end
end
