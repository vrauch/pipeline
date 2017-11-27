class AddEvoLogoToUserActivity < ActiveRecord::Migration
  def change
    add_column :user_activities, :evo_logo, :boolean, after: :resource_type, default: false
  end
end
