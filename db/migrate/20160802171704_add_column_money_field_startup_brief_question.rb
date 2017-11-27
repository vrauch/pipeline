class AddColumnMoneyFieldStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :money_field, :boolean, after: :with_icon, default: 0
  end
end
