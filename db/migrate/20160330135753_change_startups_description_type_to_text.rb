class ChangeStartupsDescriptionTypeToText < ActiveRecord::Migration
  def change
    change_column :startups, :description, :text
  end
end
