class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.integer :role, default: 0
      t.string :token
      t.integer :sent_by
      t.timestamps null: false
    end
  end
end
