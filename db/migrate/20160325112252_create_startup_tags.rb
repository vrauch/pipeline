class CreateStartupTags < ActiveRecord::Migration
  def change
    create_table :startup_tags do |t|
      t.references :startup, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
