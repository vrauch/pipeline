class ChangeTypeInStartups < ActiveRecord::Migration
  def change
    rename_column :startups, :type, :s_type
  end
end

