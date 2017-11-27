class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.references :user, index: true, foreign_key: true
      t.references :activity, index: true, foreign_key: true
      t.text :evo_text
      t.text :brand_text
      t.text :startup_text

      t.timestamps null: false
    end
  end
end
