class AddTokenToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :token, :string, index: true
  end
end
