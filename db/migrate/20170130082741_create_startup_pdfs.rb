class CreateStartupPdfs < ActiveRecord::Migration
  def change
    create_table :startup_pdfs do |t|
      t.string :file
      t.string :original_filename
      t.boolean :is_tmp, default: true
      t.integer :startup_id, index: true

      t.timestamps null: false
    end
  end
end
