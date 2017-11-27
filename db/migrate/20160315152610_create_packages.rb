class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :number_brand_briefs
      t.integer :number_external_pages
      t.integer :number_users
      t.boolean :unlimited_users
      t.integer :number_questions
      t.integer :number_startups
      t.integer :number_scorecards
      t.integer :number_scorecard_requests
      t.timestamps null: false
    end
  end
end
