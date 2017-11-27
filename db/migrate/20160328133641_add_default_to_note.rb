class AddDefaultToNote < ActiveRecord::Migration
  def change
    change_column :notes, :status, :integer, default: 0
  end
end
