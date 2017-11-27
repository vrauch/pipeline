class AddMoreFieldsToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :date_founded, :date, after: :outsearch_status
    add_column :startups, :elevator_pitch, :string, after: :date_founded
    add_column :startups, :tech_lifestage, :integer, after: :elevator_pitch
    add_column :startups, :competitors, :string, after: :funding_lifestage
    add_column :startups, :difference, :string, after: :competitors
  end
end
