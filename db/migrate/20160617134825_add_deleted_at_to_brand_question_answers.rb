class AddDeletedAtToBrandQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :brand_question_answers, :deleted_at, :datetime
    add_index :brand_question_answers, :deleted_at
  end
end
