class Request < ActiveRecord::Base
  before_save :type_actions

  SUPER_BRAND_REQUESTS = { "Technical Issue" => :tech_assistance,
                           "Package Upgrade" => :profile_update,
                           "Promo page approving" => :promo_page_approve }

  BRAND_REQUESTS = { "Technical Issue" => :tech_assistance,
                     "Promo page approving" => :promo_page_approve }

  enum request_type: [:scorecard, :tech_assistance,
                      :profile_update, :promo_page_approve, :startup, :startup_scorecard]

  belongs_to  :brand
  belongs_to  :author, class_name: 'User',
                       foreign_key: :author_id, unscoped: true
  belongs_to  :startup, unscoped: true
  belongs_to  :promo_page, unscoped: true
  has_one     :answer, foreign_key: :request_id,
                       class_name: 'RequestAnswer'

  accepts_nested_attributes_for :answer, allow_destroy: true

  delegate :full_name, to: :author, prefix: true
  delegate :photo, to: :author, prefix: true
  delegate :body, to: :answer, prefix: true
  delegate :author, to: :answer, prefix: true
  delegate :created_at, to: :answer, prefix: true
  delegate :title, to: :brand, prefix: true
  delegate :logo, to: :startup, prefix: true

  scope :startup_related_requests, ->(brand_id) { where(brand_id: brand_id) }
  scope :answered, -> { joins(:answer) }
  scope :new_requests, -> { where.not(id: answered.select(:id)) }

  validates :body, presence: true

  private

  def type_actions
    if startup_scorecard?
      self.body = "#{brand.title} " +
        'would like a scorecard for ' +
        "#{startup.title}: #{self.body}"
    end
  end
end
