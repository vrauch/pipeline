class NoteComment < ActiveRecord::Base
  belongs_to  :note
  belongs_to  :author, class_name: 'User',
                       foreign_key: :author_id, unscoped: true

  validates :body, presence: true
end
