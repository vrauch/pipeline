class CreateDiagnosticResults < ActiveRecord::Migration
  def change
    create_table :diagnostic_types do |t|
      t.string :title
      t.text :description
      t.integer :points_from
      t.integer :points_to
      t.timestamps null: false
    end
  end
end
