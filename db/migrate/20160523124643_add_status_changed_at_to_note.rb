class AddStatusChangedAtToNote < ActiveRecord::Migration
  def change
    add_column :notes, :status_changed_at, :date, after: :status
  end
end
