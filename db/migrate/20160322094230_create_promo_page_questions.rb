class CreatePromoPageQuestions < ActiveRecord::Migration
  def change
    create_table :promo_page_questions do |t|
      t.references :promo_page
      t.string :question_text, :limit => 255
      t.integer :answer_type, :limit => 3
      t.timestamps null: false
    end
  end
end
