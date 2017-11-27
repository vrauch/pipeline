class AddIndexBrandBriefAnswersBrandCategoryValueId < ActiveRecord::Migration
  def change
    add_index :brand_brief_answers, :category_value_id
  end
end
