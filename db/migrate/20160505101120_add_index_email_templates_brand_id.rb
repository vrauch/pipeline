class AddIndexEmailTemplatesBrandId < ActiveRecord::Migration
  def change
    add_index :email_templates, :brand_id
  end
end
