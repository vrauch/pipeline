class Picture < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
  belongs_to :imageable, polymorphic: true
end
