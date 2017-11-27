class CreateListStartups < ActiveRecord::Migration
  def change
    create_table :list_startups do |t|
      t.references :list, index: true, foreign_key: true
      t.references :startup, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
