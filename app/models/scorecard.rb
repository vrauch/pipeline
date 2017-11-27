class Scorecard < ActiveRecord::Base
  include AASM
  mount_uploader :logo, PictureUploader
  mount_uploader :product_image, PictureUploader
  mount_uploader :rs_product_image, PictureUploader

  belongs_to :scorecard_template, counter_cache: :scorecards_count
  belongs_to :startup
  belongs_to :user
  has_many :scorecard_answers, dependent: :destroy, inverse_of: :scorecard
  has_many :variants, through: :scorecard_answers
  has_one :brand, through: :scorecard_template

  accepts_nested_attributes_for :scorecard_answers

  before_create :generate_token
  before_save :generate_scores

  STEPS = %w[template overview product collaboration business recommendation].freeze
  attr_writer :current_step
  attr_accessor :answers_quantity

  enum state: {
    draft: 0,
    complete: 1,
    sent: 2
  }

  validates :scorecard_template_id, presence: { message: 'Scorecard template is required' }
  validates :startup_id, presence: { message: 'Startup is required' }

  validates :title, length: { maximum: 50, too_long: 'Title is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :location, length: { maximum: 50, too_long: 'Location is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :website, length: { maximum: 50, too_long: 'Website is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :macro_trends, length: { maximum: 50, too_long: '' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :micro_trends, length: { maximum: 50, too_long: '' }, if: lambda { |o| o.current_step == STEPS.last }
  validate :macro_trends_max_length, if: lambda { |o| o.current_step == STEPS.last }
  validate :micro_trends_max_length, if: lambda { |o| o.current_step == STEPS.last }
  validates :date_founded, length: { maximum: 14, too_long: 'Funding Date is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :dev_stage, length: { maximum: 30, too_long: 'Development Stage is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :fun_stage, length: { maximum: 60, too_long: 'Funding Stage is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :brand_experience, length: { maximum: 125, too_long: 'Brand experience is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :description, length: { maximum: 300, too_long: 'Description is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :problem_startup_solves, length: { maximum: 300, too_long: 'Problem Startup Solves is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :how_it_works, length: { maximum: 300, too_long: 'How It Works is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :recommendation, length: { maximum: 800, too_long: 'Recommendation is too long (maximum %{count} characters)' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :product_image_title, :rs_product_image_title, length: { maximum: 40, message: 'Maximum length for Image Title is 40 chars' }, if: lambda { |o| o.current_step == STEPS.last }

  validates :logo, :product_image, :rs_product_image, file_size: { maximum: 5.megabyte.to_i }, if: lambda { |o| o.current_step == 'recommendation' }
  validate :validate_answers, if: lambda { |o| STEPS[2..4].include?(o.current_step) }
  # validate :validate_all_answers, if: lambda { |o| o.current_step == STEPS.last }
  validates_uniqueness_of :startup, scope: :scorecard_template,
    message: 'Scorecard has already been created for this startup with this template',
    if: lambda { |o| o.current_step == STEPS.first || o.current_step == STEPS.last },
    on: :create

  validates :title, presence: { message: 'Title is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :location, presence: { message: 'Location is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :website, presence: { message: 'Website is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validate :precence_macro_trends, if: lambda { |o| o.current_step == STEPS.last }
  validate :precence_micro_trends, if: lambda { |o| o.current_step == STEPS.last }
  validates :dev_stage, presence: { message: 'Development Stage is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :fun_stage, presence: { message: 'Funding Stage is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :recommendation, presence: { message: 'Recommendation is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :description, presence: { message: 'Startup Description is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :brand_experience, presence: { message: 'Brand Experience is required' }, if: lambda { |o| o.current_step == STEPS.last }
  validates :date_founded, presence: { message: 'Date Founded is required' }, if: lambda { |o| o.current_step == STEPS.last }

  validates :problem_startup_solves, presence: { message: 'Startup Solves is required' }, if: lambda{ |o|
    o.current_step == STEPS.last &&
    (o.scorecard_template.ls_product_section_type.to_i == 0 ||
    o.scorecard_template.rs_product_section_type.to_i == 0)
  }

  validates :how_it_works, presence: { message: 'How It Works is required' }, if: lambda{ |o|
    o.current_step == STEPS.last &&
    (o.scorecard_template.ls_product_section_type.to_i == 1 ||
    o.scorecard_template.rs_product_section_type.to_i == 1)
  }

  validates :product_image, presence: { message: 'Product Image is required' }, if: lambda{ |o|
    o.current_step == STEPS.last && o.scorecard_template.ls_product_section_type.to_i == 2
  }

  validates :rs_product_image, presence: { message: 'Product Image is required' }, if: lambda{ |o|
    o.current_step == STEPS.last && o.scorecard_template.rs_product_section_type.to_i == 2
  }

  default_scope { order(updated_at: :desc) }
  scope :search_by_title, -> (search) { where('lower(title) like ?', "%#{search.downcase}%")}


  def validate_answers
    if answers_quantity != 5
      errors.add(:answers, 'Please select an answer for each question')
    end
  end

  def validate_all_answers
    if scorecard_answers.count != 15
      errors.add(:answers, 'Please select an answer for each question')
    end
  end

  def precence_micro_trends
    if micro_trends && micro_trends.length == 0
      errors.add(:micro_trends,
        "#{scorecard_template.try(:micro_categories_title).try(:capitalize)} is required")
    end
  end

  def precence_macro_trends
    if macro_trends && macro_trends.length == 0
      errors.add(:macro_trends,
        "#{scorecard_template.try(:macro_categories_title).try(:capitalize)} is required")
    end
  end

  def micro_trends_max_length
    max = Scorecard.max_length_of(:micro_trends)
    if micro_trends && micro_trends.length > max
      errors.add(:micro_trends,
        "#{scorecard_template.try(:micro_categories_title).try(:capitalize)} is too long (maximum #{max} characters)")
    end
  end

  def macro_trends_max_length
    max = Scorecard.max_length_of(:macro_trends)
    if macro_trends && macro_trends.length > max
      errors.add(:macro_trends,
        "#{scorecard_template.try(:macro_categories_title).try(:capitalize)} is too long (maximum #{max} characters)")
    end
  end

  aasm column: :state, enum: true do
    state :draft, initial: true
    state :complete
    state :sent

    event :save_draft do
      transitions from: :draft, to: :complete
    end

    event :push, after: :push_to_brand do
      transitions from: :complete, to: :sent
    end
  end

  def push_to_brand
    # brand notification
  end

  def self.max_length_of(field)
    validators = validators_on(field.to_sym)
      .select{ |v| v.class == ActiveModel::Validations::LengthValidator }.first
    validators ? validators.options[:maximum] : 0
  end

  def self.regenerate_all_scores!
    all.each { |s| s.generate_scores! }
  end

  def build_from_startup
    if startup_id
      copy_startup_attributes!
      return true
    else
      return false
    end
  end

  def form_answers
    # variants.joins(:question).pluck('questions.id', :id).to_h
    # do this because params - string
    variants.joins(:question).pluck('questions.id', :id).map { |e| e.collect(&:to_s) }.to_h
  end

  def clear_answers!
    scorecard_answers.destroy_all
  end

  def logo_dimensions
    logo.store_dimensions
  end

  def build_answers(answers)
    answers.each { |answer_id, variant_id| self.scorecard_answers.build(variant_id: variant_id) }
  end

  def current_step
    @current_step || STEPS.first
  end

  def next_step
    self.current_step = STEPS[STEPS.index(current_step)+1]
  end

  def previous_step
    self.current_step = STEPS[STEPS.index(current_step)-1]
  end

  def first_step?
    current_step == STEPS.first
  end

  def last_step?
    current_step == STEPS.last
  end

  def all_valid?
    STEPS.values_at(0, 1, 5).all? do |step, key|
      self.current_step = step
      valid?
    end
  end

  def initial
    title ? title[0].try(:upcase) : 'S'
  end

  def generate_token!
    generate_token
    save
  end

  def pc_score
    product_total_score * 1.5 + collaboration_total_score
  end

  alias_attribute :p_score, :product_total_score
  alias_attribute :c_score, :collaboration_total_score
  alias_attribute :b_score, :business_total_score

  alias x_coordinate b_score

  alias y_coordinate pc_score

  def generate_scores!
    generate_scores
    save(validate: false)
  end

private

  def generate_scores
    variants = self.variants.where(id: self.scorecard_answers.pluck(:variant_id))
    self.product_total_score =
      variants.product_from(scorecard_template.startup_model).total_score

    self.collaboration_total_score =
      variants.collaboration_from(scorecard_template.startup_model).total_score

    self.business_total_score =
      variants.business_from(scorecard_template.startup_model).total_score
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def copy_startup_attributes!
    s = startup.decorate
    s = StartupSummaryDecorator.decorate(s)
    self.title = s.title
    self.description = s.elevator_pitch
    self.website = s.website
    self.location = s.location
    self.logo = s.logo
    self.logo_cache = s.logo_cache
    self.date_founded = s.date_founded.try(:strftime, '%B %Y') || s.created_at.try(:strftime, '%B %Y') || DateTime.now.try(:strftime, '%B %Y')
    self.dev_stage = s.dev_stages.join(', ')
    self.fun_stage = s.fun_stages.join(', ')
    self.brand_experience = s.brand_experience
    self.problem_startup_solves = s.problem_startup_solves
  end
end
