class CreateRequestAnswers < ActiveRecord::Migration
  def change
    create_table :request_answers do |t|
      t.references :request, index: true, foreign_key: true
      t.integer :author_id
      t.text :body

      t.timestamps null: false
    end
  end
end
