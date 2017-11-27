class AddUpToToStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :up_to, :integer, after: :detail
  end
end
