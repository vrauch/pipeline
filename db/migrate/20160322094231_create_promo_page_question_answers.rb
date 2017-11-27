class CreatePromoPageQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :promo_page_question_answers do |t|
      t.references :promo_page_question
      t.text :answer_text, :limit => 1000
      t.timestamps null: false
    end
  end
end
