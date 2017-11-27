class AddColumnToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :new, :boolean, default: true, after: :body
  end
end
