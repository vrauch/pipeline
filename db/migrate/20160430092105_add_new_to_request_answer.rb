class AddNewToRequestAnswer < ActiveRecord::Migration
  def change
    add_column :request_answers, :new, :boolean, default: 1, after: :body
  end
end
