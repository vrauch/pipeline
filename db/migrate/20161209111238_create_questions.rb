class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :body
      t.integer :question_type
      t.integer :score_type
      t.integer :question_for
      t.boolean :is_default, default: false

      t.timestamps null: false
    end
  end
end
