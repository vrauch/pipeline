class AddMandatoryToStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :mandatory, :boolean, after: :up_to, default: 0
  end
end
