class AddIndexBrandQuestionAnswers < ActiveRecord::Migration
  def change
    add_index :brand_question_answers, :brand_question_id
  end
end
