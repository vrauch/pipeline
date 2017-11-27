class CreateBrandUsers < ActiveRecord::Migration
  def change
    create_table :brand_users do |t|
      t.references :brand, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
