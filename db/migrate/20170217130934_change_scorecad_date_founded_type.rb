class ChangeScorecadDateFoundedType < ActiveRecord::Migration
  def up
    change_column :scorecards, :date_founded, :string
  end

  def down
    change_column :scorecards, :date_founded, :date
  end
end
