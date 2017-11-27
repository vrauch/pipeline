class AddFieldsToFounder < ActiveRecord::Migration
  def change
    add_column :founders, :startup_id, :integer
    add_index :founders, :startup_id
    add_column :founders, :avatar, :string
  end
end
