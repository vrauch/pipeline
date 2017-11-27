class StartupTag < ActiveRecord::Base
  enum team: [:brand, :evo]

  belongs_to :startup
  belongs_to :tag

  after_commit :rebuild_indexes

  validates_uniqueness_of :startup_id, scope: [:tag_id]

  scope :all_startup_tags, -> (startup_ids, user_ids) do
    joins(:tag)
    .where(tags: { user_id: user_ids }, startup_tags: { startup_id: startup_ids } )
  end

  def self.startup_tags(startup_ids, user_ids)
    startup_tags = preload(:tag).all_startup_tags(startup_ids, user_ids)
    tags = {}
    startup_tags.each do |startup_tag|
      if tags.key?(startup_tag.startup_id)
        tags[startup_tag.startup_id][:tags] << startup_tag.tag
        tags[startup_tag.startup_id][:tags_count] += 1
      else
        tags[startup_tag.startup_id] = { tags: [startup_tag.tag], tags_count: 1 }
      end
    end
    tags
  end

  private
  def rebuild_indexes
    IndexWorker.perform_async
  end
end
