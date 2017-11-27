class AddFieldsToBriefQuestion < ActiveRecord::Migration
  def change
    add_column :brief_questions, :progress_step, :integer
    add_column :brief_questions, :order, :integer
  end
end
