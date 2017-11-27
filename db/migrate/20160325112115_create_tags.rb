class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.integer :team

      t.timestamps null: false
    end
  end
end
