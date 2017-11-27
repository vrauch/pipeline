class CreateUserDiagnosticSummaries < ActiveRecord::Migration
  def change
    create_table :user_diagnostic_summaries do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps null: false
    end
  end
end
