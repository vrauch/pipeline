class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :title
      t.integer :score

      t.timestamps null: false
    end
  end
end
