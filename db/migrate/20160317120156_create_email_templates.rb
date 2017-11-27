class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.references :brand
      t.string :email_logo, :limit => 255
      t.string :email_color, :limit => 7
      t.string :copy_for_email, :limit => 255
      t.timestamps null: false
    end
  end
end
