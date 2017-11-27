class CreateBrandQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :brand_question_answers do |t|
      t.references :brand_question
      t.text :answer_text, :limit => 1000
      t.timestamps null: false
    end
  end
end
