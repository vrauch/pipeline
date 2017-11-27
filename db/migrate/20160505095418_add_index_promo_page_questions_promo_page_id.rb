class AddIndexPromoPageQuestionsPromoPageId < ActiveRecord::Migration
  def change
    add_index :promo_page_questions, :promo_page_id
  end
end
