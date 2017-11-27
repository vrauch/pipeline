class AddTimestampsToStartupPromoBrief < ActiveRecord::Migration
  def change
    add_timestamps :startup_promo_briefs, null: false, default: Time.now
  end
end
