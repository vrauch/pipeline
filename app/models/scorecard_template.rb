class ScorecardTemplate < ActiveRecord::Base
  mount_uploader :logo, PictureUploader

  STEPS = %w[template business preview].freeze
  attr_writer :current_step
  PRODUCT_SECTION_TYPES = %i[ problem_startup_solves how_it_works product_image ].freeze

  belongs_to :brand
  belongs_to :user
  has_many :scorecard_templates_questions, inverse_of: :scorecard_template, dependent: :destroy
  has_many :questions, through: :scorecard_templates_questions
  has_many :scorecards, dependent: :destroy

  accepts_nested_attributes_for :questions

  # default_scope { order(updated_at: :desc) }

  enum scorecard_type: %i[ standard brief ]
  enum startup_model: %i[ b2c b2b ]

  after_commit :destroy_free_questions

  validates :title_brand, presence: { message: 'Brand is required' }
  validates :title_brief, presence: { message: 'Brief is required' }
  validates :title_year, presence: { message: 'Year is required' }
  validates :macro_categories_title, presence: { message: 'Macro categories title is required' }
  validates :micro_categories_title, presence: { message: 'Micro categories title is required' }
  validates :ls_product_section_type, presence: { message: 'Brand is required' }
  validates :rs_product_section_type, presence: { message: 'Brand is required' }
  validates :scorecard_type, presence: { message: 'Scorecard type is required' }
  validates :startup_model, presence: { message: 'Startup model is required' }
  validates :brand_id, presence: { message: 'Brand is required' }

  validates :macro_categories_title, :micro_categories_title, length: { maximum: 20 }
  validates :logo, file_size: { maximum: 5.megabyte.to_i }

  validate :validate_ps_types, if: lambda { |o| o.current_step == 'template' }
  validate :validate_questions, if: lambda { |o| o.current_step == 'business' }

  scope :search_by_scorecard_title, -> (search) do
    joins(:scorecards).where('lower(scorecards.title) like ?', "%#{search.downcase}%")
  end

  scope :order_by_scorecards_count, -> { order('scorecards_count DESC') }
  scope :order_by_created_date, -> { order(created_at: :desc) }

  def self.reset_all_counters
    all.each { |st|  ScorecardTemplate.reset_counters(st.id, :scorecards) }
  end

  def self.max_length_of(field)
    validators = validators_on(field.to_sym)
      .select{ |v| v.class == ActiveModel::Validations::LengthValidator }.first
    validators ? validators.options[:maximum] : 0
  end

  def create_scorecards_xls
    Export::Xls.generate_xls_from_scorecard_template(self)
  end

  def validate_questions
    errors.add(:questions, 'Please select 5 business alignment evaluation questions') if questions.select{ |q| q.is_selected == '1' }.size != 5
  end

  def validate_ps_types
    if ls_product_section_type == rs_product_section_type && [0,1].include?(ls_product_section_type)
      errors.add(:product_section_types,
        'Please select two different options for the product section (or two product images)')
    end
  end

  def title
    "#{title_brand}-#{title_brief}-#{title_year}"
  end

  def can_edit?
    scorecards.count == 0
  end

  def initial
    title_brand[0] if title_brand
  end

  def get_logo
    if logo.present?
      logo
    elsif brand && brand.logo.present?
      brand.logo
    end
  end

  def logo_dimensions
    get_logo.store_dimensions if get_logo.present?
  end

  def build_questions_from(questions_list)
    questions_list.each do |q|
      tmp_question = questions.build(q.attributes)
      q.variants.each do |v|
        tmp_question.variants.build(v.attributes)
      end
    end
  end

  def build_custom_questions(params)
    params.each_with_index do |ps, i|
       q = questions.build(ps)
    end
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
    STEPS.all? do |step|
      self.current_step = step
      valid?
    end
  end

  private
  def destroy_free_questions
    DeleteQuestionsWorker.perform_async
  end
end
