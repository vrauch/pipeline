class CreateAnnouncementUsers < ActiveRecord::Migration
  def change
    create_table :announcement_users do |t|
      t.references :announcement
      t.references :user
      t.timestamps null: false
    end
  end
end
