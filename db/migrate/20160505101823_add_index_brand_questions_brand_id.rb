class AddIndexBrandQuestionsBrandId < ActiveRecord::Migration
  def change
    add_index :brand_questions, :brand_id
  end
end
