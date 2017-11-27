class AddAboutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :about, :text, after: :role
  end
end
