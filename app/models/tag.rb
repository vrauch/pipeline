class Tag < ActiveRecord::Base
  paginates_per 100

  has_many :startup_tags
  has_many :startups, through: :startup_tags

  scope :search_by_title, -> (search) { where('lower(title) like ?', "%#{search.downcase}%")}

  class << self
    def save_tags(tag_titles, user)
      titles = tag_titles.split(%r{,\s*})

      tags, tags_for_save = [], []
      titles.each do |title|
        tags_for_save << { title: title, alias: title.downcase.underscore }
      end
      user_ids = user.evo_team? ? User.evo_users.pluck(:id) : user.brand_user_ids
      tags_for_save.each do |tag|
        tags << Tag.find_or_create_by(alias: tag[:alias], user_id: user_ids) do |t|
          t.title, t.alias, t.user_id = tag[:title], tag[:alias], user.id
        end
      end
      tags
    end

  end

end
