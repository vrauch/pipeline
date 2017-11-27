class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :alias, index: true
      t.text :evo_pattern
      t.text :brand_pattern
      t.text :startup_pattern

      t.timestamps null: false
    end

  end
end
