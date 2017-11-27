class EmailTemplate < ActiveRecord::Base
  mount_uploader :email_logo, PictureUploader

  DEFAULT_TEXT = 'We are excited to learn more about your startup. Please click the button below to fill out the rest of your profile'

  attr_accessor :current_step

  belongs_to :brand

  # validates :copy_for_email, presence: true, if: :email_step?
  validates :email_color, length: {minimum: 7, maximum: 7}, allow_blank: true
  validates_format_of :email_color, with: /\A#(?:[0-9a-fA-F]{3,6})\Z/, allow_blank: true
  validates :copy_for_email, length: {maximum: 255}, allow_blank: true

  def logo_dimensions
    email_logo.store_dimensions
  end

  private

  def email_step?
    self.current_step == Brand::STEPS.second
  end
end
