class AddColumnStartupIdToNotes < ActiveRecord::Migration
  def up
    add_column :notes, :startup_id, :integer, after: :author_id

    sql = 'UPDATE notes n
           JOIN startup_notes sn ON sn.note_id = n.id
           SET n.startup_id = sn.startup_id'
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    remove_column :notes, :startup_id
  end
end
