class StartupPdf < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :startup
  mount_uploader :file, PdfUploader

  validates :startup, :file, :original_filename, presence: true
  validates :file, file_size: { maximum: 2.megabyte.to_i }

  scope :not_tmp, -> { where(is_tmp: false) }
  scope :only_tmp, -> { where(is_tmp: true) }

  def real_save!
    update(is_tmp: false)
  end
end
