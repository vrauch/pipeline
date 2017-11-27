class AddColumnsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :contact_name, :string, :limit => 255, after: :location
    add_column :brands, :contact_email, :string, :limit => 255, after: :contact_name
    add_column :brands, :color, :string, :limit => 7, after: :contact_email
    add_column :brands, :package_id, :integer, after: :creator_id
  end
end
