class AddDeletedAtToStartupPdfs < ActiveRecord::Migration
  def change
    add_column :startup_pdfs, :deleted_at, :datetime
    add_index :startup_pdfs, :deleted_at
  end
end
