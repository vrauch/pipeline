class AddDeletedAtToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :deleted_at, :datetime, after: :number_scorecard_requests
    add_index :packages, :deleted_at
  end
end
