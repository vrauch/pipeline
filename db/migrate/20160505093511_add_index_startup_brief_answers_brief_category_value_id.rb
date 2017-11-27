class AddIndexStartupBriefAnswersBriefCategoryValueId < ActiveRecord::Migration
  def change
    add_index :startup_brief_answers, :category_value_id
  end
end
