class AddAliasToInsightGroups < ActiveRecord::Migration
  def change
    add_column :insight_groups, :alias, :string, after: :id
  end
end
