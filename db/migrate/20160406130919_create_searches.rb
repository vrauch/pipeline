class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.integer :user_id
      t.integer :number_startups
      t.string :title
      t.string :search
      t.datetime :added_from
      t.datetime :added_to
      t.integer :startup_type
      t.timestamps null: false
    end
  end
end
