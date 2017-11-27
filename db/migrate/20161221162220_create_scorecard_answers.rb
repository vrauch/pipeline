class CreateScorecardAnswers < ActiveRecord::Migration
  def change
    create_table :scorecard_answers do |t|
      t.integer :scorecard_id, index: true
      t.integer :variant_id, index: true

      t.timestamps null: false
    end
  end
end
