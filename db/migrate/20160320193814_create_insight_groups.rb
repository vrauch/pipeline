class CreateInsightGroups < ActiveRecord::Migration
  def change
    create_table :insight_groups do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
