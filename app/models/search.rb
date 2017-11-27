class Search < ActiveRecord::Base
  EVO_SUBMISSIONS = [['All', 'all_startups'], ['Founder Evol8tion', 'founder_evolution'],
                 ['Evol8tion Generated', 'evo_generated'], ['Founder - Brand', 'founder_brand'],
                 ['Watchlist', 'watchlist']].freeze


  BRAND_SUBMISSIONS = [['All', 'all_startups'], ['Founder Submitted', 'founder'],
                       ['Evol8tion Curated', 'evolution'], ['Watchlist', 'watchlist']].freeze

  belongs_to :user
  has_many :search_categories, dependent: :destroy, autosave: true
  has_many :category_values, through: :search_categories

  scope :saved_search, -> (user) do
    user_ids(user).includes(:user).order(updated_at: :desc)
  end

  scope :user_search, -> (id, user)  do
    user_ids(user).where(id: id).includes(:category_values).first
  end

  scope :user_ids, -> (user) do
    user_ids = case
      when user.brand_team?
        user.brand_user_ids
      when user.evo_team?
        User.evo_users.pluck(:id)
      else
        []
      end
    where(user_id: user_ids)
  end

  validates :name, presence: true
end
