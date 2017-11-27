class AddColumnToStartupProfileQuestion < ActiveRecord::Migration
  def change
    add_column :startup_profile_questions, :answered, :boolean, after: :body, default: 0
  end
end
