class AddJobTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job_title, :string, after: :role
  end
end
