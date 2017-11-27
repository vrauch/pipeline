class AddPhotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo, :string, after: :about
  end
end
