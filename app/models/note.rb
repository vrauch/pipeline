class Note < ActiveRecord::Base
  enum status: [:assigned, :done]

  acts_as_paranoid

  COMMENT = 'comment'
  TASK = 'task'

  belongs_to :startup
  belongs_to :author,   class_name: 'User',
                        foreign_key: :author_id, unscoped: true
  belongs_to :assignee, class_name: 'User',
                        foreign_key: :assignee_id, unscoped: true
  has_many   :comments, class_name: 'NoteComment'

  validates :note_text, presence: true
  # validates :due_date, presence: true
  # validates :assignee_id, presence: true

  scope :reminders, ->(user_id) do
    where.not(assignee_id: nil)
    .where('author_id = :user_id OR assignee_id = :user_id', { user_id: user_id })
  end
  scope :tasks, -> { where.not assignee_id: nil }
  scope :author_or_assignee, -> (user) do
    where('author_id = :user_id OR assignee_id = :user_id', user_id: user.id)
  end

  delegate :full_name, to: :author, prefix: true
  delegate :photo, to: :author, prefix: true
  delegate :full_name, to: :assignee, prefix: true
  
end