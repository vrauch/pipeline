class PromoPage < ActiveRecord::Base
  acts_as_paranoid
  enum promo_page_status: [:waiting, :published, :rejected, :inactive]

  STATUSES = { waiting: 'Waiting<br/>for review', published: 'Published',
               rejected: 'Rejected', inactive: 'Inactive'}

  STEPS = %w[intro details sign_up questions preview]

  attr_writer :current_step
  attr_accessor :previous, :limit_question_reached

  belongs_to :brand, unscoped: true
  belongs_to :creator, class_name: 'User'
  has_many :promo_page_details
  has_one :request
  has_many :promo_page_questions
  has_many :startups
  before_create :promo_token
  before_create :promo_alias

  mount_uploader :cover_image, PictureUploader
  mount_uploader :form_image, PictureUploader

  accepts_nested_attributes_for :promo_page_details, reject_if: :all_blank,
                                allow_destroy: true
  accepts_nested_attributes_for :promo_page_questions, reject_if: :all_blank,
                                allow_destroy: true



  validates_presence_of :reason, if: :rejected?
  validates :name, presence: true, if: :intro_step?
  validate :validate_question_count

  delegate :title, to: :brand, prefix: true

  scope :enable_for_review, -> do
    where(promo_page_status: [promo_page_statuses[:waiting],
                              promo_page_statuses[:published],
                              promo_page_statuses[:rejected]])
  end

  scope :published, -> { where promo_page_status: promo_page_statuses[:published] }

  def current_step
    @current_step || STEPS.first
  end

  def next_step
    self.current_step = STEPS[STEPS.index(current_step) + 1]
  end

  def previous_step
    self.previous = self.current_step
    self.current_step = STEPS[STEPS.index(current_step) - 1]
  end

  def first_step?
    self.current_step == STEPS.first
  end

  def last_step?
    self.current_step == STEPS.last
  end

  protected

  def validate_question_count
    if promo_page_questions.size - brand.brand_questions.count > brand.package.number_questions
      self.limit_question_reached = true
    end
  end

  def promo_token
    loop do
      @invite_token = Devise.friendly_token
      break @invite_token unless self.class.exists?(token: @invite_token)
    end
    self.token = @invite_token
  end

  def promo_alias
    i = 0
    loop do
      name_alias = self.name.gsub(/[^0-9A-Za-z]/, '_').downcase
      @name_alias = i == 0 ? name_alias : "#{name_alias}_#{i}"
      break @name_alias unless self.class.exists?(alias: @name_alias)
      i += 1
    end
    self.alias = @name_alias
  end

  def intro_step?
    self.current_step == STEPS.first
  end

  def preview_step?
    self.current_step == STEPS.last
  end

  def questions_step?
    self.current_step == STEPS.fourth
  end

end
