class List < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many   :list_startups, dependent: :destroy
  has_many   :startups, through: :list_startups

  validates :name, presence: true

  default_scope -> { preload(:startups) }

  scope :team_lists, -> (user) do
    case
    when user.evo_team?
      user_ids = User.evo_users.pluck(:id)
    when user.brand_team?
      user_ids = user.brand_user_ids
    end
    where(author_id: user_ids, favorite: false)
  end

  scope :sort, -> { order(:priority, created_at: :desc) }

  scope :favorite_list, -> (user) { where(author_id: user.id, favorite: true).first }
end
