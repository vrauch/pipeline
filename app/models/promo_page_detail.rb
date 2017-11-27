class PromoPageDetail < ActiveRecord::Base
  mount_uploader :inspire_image, PictureUploader
  
  attr_accessor :current_step

  belongs_to :promo_page

  before_save :params_details
  before_update :clean_images
  validate :inspire_video_url
  after_validation :add_video_image
  mount_uploader :image_video, PictureUploader

  def params_details
    if inspire_video.present?
      video = VideoInfo.new(inspire_video)
      self.inspire_video = video.embed_url
    end
  end
  
  def add_video_image
    if inspire_video.present? && self.changed.include?('inspire_video')
      begin
        video = VideoInfo.new(inspire_video)
        if video.available?
          self.remote_image_video_url = video.thumbnail_large
        end
      rescue
      end
    end
  end

  protected

  def details_step?
    self.current_step == PromoPage::STEPS.second
  end

  def inspire_video_url
    if inspire_video.present?
      begin
        videoInfo = VideoInfo.new(inspire_video)
      rescue
        errors.add(:inspire_video, "is not video url")
      end
    end
  end

  def clean_images
    if inspire_video.present?
      self.update_columns(inspire_image: nil)
    elsif inspire_image.present? || inspire_video.blank?
      self.update_columns(image_video: nil)
    end
  end
end
