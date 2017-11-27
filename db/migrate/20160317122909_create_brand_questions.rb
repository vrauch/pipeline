class CreateBrandQuestions < ActiveRecord::Migration
  def change
    create_table :brand_questions do |t|
      t.references :brand
      t.string :question_text, :limit => 255
      t.integer :answer_type, :limit => 3
      t.timestamps null: false
    end
  end
end
