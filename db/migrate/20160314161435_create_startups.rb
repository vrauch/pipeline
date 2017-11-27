class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|
      t.string :title
      t.string :description
      t.string :frame_of_reference
      t.string :location
      t.string :website
      t.string :funding_lifestage
      t.string :contact_name
      t.string :contact_email
      t.string :twitter
      t.integer :type

      t.timestamps null: false
    end
  end
end
