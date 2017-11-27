class AnnouncementUser < ActiveRecord::Base
  belongs_to :announcement_receiver
  belongs_to :user
end
