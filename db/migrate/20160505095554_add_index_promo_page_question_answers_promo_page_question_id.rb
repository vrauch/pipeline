class AddIndexPromoPageQuestionAnswersPromoPageQuestionId < ActiveRecord::Migration
  def change
    add_index :promo_page_question_answers, :promo_page_question_id
  end
end
