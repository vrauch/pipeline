class AddEvoCounterFieldToStartup < ActiveRecord::Migration
  def change
    add_column :startups, :evo_tags_count, :integer, default: 0, after: :owner_id
  end
end
