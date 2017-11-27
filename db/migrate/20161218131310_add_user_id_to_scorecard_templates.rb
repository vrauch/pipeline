class AddUserIdToScorecardTemplates < ActiveRecord::Migration
  def change
    add_column :scorecard_templates, :user_id, :integer, index: true
  end
end
