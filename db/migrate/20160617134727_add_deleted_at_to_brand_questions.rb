class AddDeletedAtToBrandQuestions < ActiveRecord::Migration
  def change
    add_column :brand_questions, :deleted_at, :datetime
    add_index :brand_questions, :deleted_at
  end
end
