class AnnouncementImage < ActiveRecord::Base
  mount_uploader :image, AnnouncementImageUploader
end
