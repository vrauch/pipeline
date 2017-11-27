class CreateBrandPackages < ActiveRecord::Migration
  def change
    create_table :brand_packages, :id => false do |t|
      t.references :brand, brand_questions: true, foreign_key: true
      t.references :package, brand_questions: true, foreign_key: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end
