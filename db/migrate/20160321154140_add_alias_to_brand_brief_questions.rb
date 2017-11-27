class AddAliasToBrandBriefQuestions < ActiveRecord::Migration
  def change
    add_column :brand_brief_questions, :alias, :string, after: :content
  end
end
