class CreateFounders < ActiveRecord::Migration
  def change
    create_table :founders do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
