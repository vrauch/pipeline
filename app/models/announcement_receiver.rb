class AnnouncementReceiver < ActiveRecord::Base
  #enum receiver_type: [:startup_type, :brand_type]
  belongs_to :announcement
  belongs_to :startup, foreign_key: :receiver_id, unscoped: true
  belongs_to :brand, foreign_key: :receiver_id, unscoped: true
  has_many :announcement_users
  has_many :users, through: :announcement_users

  # def self.default_scope
  #   includes(:startup, :brand)
  # end
end
