class AddColumnStyleToStartupBriefQuestion < ActiveRecord::Migration
  def change
    add_column :startup_brief_questions, :style, :string, after: :alias
  end
end
