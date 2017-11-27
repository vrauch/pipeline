class Founder < ActiveRecord::Base
  attr_accessor :skip_validation

  belongs_to :startup, inverse_of: :founders

  validates :name, presence: true, unless: :skip_validation

  mount_uploader :avatar, PictureUploader
end
