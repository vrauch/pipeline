class RemoveDefaultValueFromStartupPromoBriefs < ActiveRecord::Migration
  def change
    change_column_default(:startup_promo_briefs, :created_at, nil)
    change_column_default(:startup_promo_briefs, :updated_at, nil)
  end
end
