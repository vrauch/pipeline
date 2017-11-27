class ChangeFundlingLifestageColumnType < ActiveRecord::Migration
  def change
    change_column :startups, :funding_lifestage, :integer
  end
end
