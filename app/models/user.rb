class User < ActiveRecord::Base
  include Roles
  acts_as_paranoid
  mount_uploader :photo, UserPictureUploader

  attr_accessor :promo_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable, :validatable

  ROLES = { quest: 'Guest', startup: 'Startup User', brand: 'Team User',
            brand_super: 'Super User', evo: 'Evo Team User',
            evo_super: 'Evo Team Super User' }

  ACTIVITY = { active: 'Active', inactive: 'Inactive' }

  enum active: [:inactive, :active]

  belongs_to :invite, foreign_key: :invite_token_id, dependent: :destroy
  has_one  :startup, validate: true, foreign_key: :owner_id
  has_many :startup_watchers, foreign_key: :watcher_id
  has_many :watching_startups, through: :startup_watchers,
           source: :startup
  has_many :diagnostic_summaries, class_name: 'UserDiagnosticSummary'
  has_many :insight_summaries, class_name: 'UserInsightSummary'

  has_one :insight_summary_act, -> { where(insight_group_id: 1) },
          class_name: 'UserInsightSummary'

  has_one :summary_diagnostic_type, through: :insight_summary_act, source: :diagnostic_type

  has_many :insight_summaries_groups, through: :insight_summaries,
                                      source: :insight_group
  has_many :announcement_users
  has_many :announcements, through: :announcement_users
  has_many :startup_profile_questions
  has_many :lists, foreign_key: :author_id
  has_many :posted_notes, foreign_key: :author_id, class_name: 'Note'
  has_many :assigned_notes, foreign_key: :assignee_id, class_name: 'Note'
  has_many :requests, foreign_key: :author_id
  has_many :request_answers, foreign_key: :author_id
  has_one  :brand_user, dependent: :destroy
  has_one  :brand, through: :brand_user
  has_many :note_comments, foreign_key: :author_id
  has_one  :favorite_list, -> { where(favorite: true) },
                           foreign_key: :author_id, class_name: 'List'
  has_many :user_activities, dependent: :destroy
  has_many :scorecard_templates, dependent: :destroy
  has_many :scorecards, dependent: :destroy

  delegate :id, to: :brand, prefix: true
  delegate :id, to: :startup, prefix: true
  delegate :user_ids, to: :brand, prefix: true, allow_nil: true
  delegate :logo, to: :startup, prefix: true

  accepts_nested_attributes_for :diagnostic_summaries

  validates :full_name,             presence: true

  validates :password,              length: { minimum: 6 },
                                    confirmation: true, if: :validate_password?

  validates :password_confirmation, presence: true, if: :password_present?

  after_create :create_favorite_list

  scope :evo_users, -> { where(role: [roles[:evo], roles[:evo_super]]) }
  scope :evo_super_users, -> { where(role: roles[:evo_super]) }
  scope :brand_users, -> { where(role: [roles[:brand], roles[:brand_super]]) }
  scope :brand_super_users, -> { where(role: roles[:brand_super]) }
  scope :startup_users, -> { where(role: [roles[:startup]]) }
  scope :startup_brand_users, -> {
    where(role: [roles[:startup], roles[:brand], roles[:brand_super]])
  }

  def initial
    full_name[0, 1]
  end

  def f_name
    full_name.split(' ')[0]
  end

  def l_name
    full_name.split(' ')[1]
  end

  def has_in_favorites?(startup)
    favorite_list = List.favorite_list(self)
    favorite_list.blank? ? false : favorite_list.startups.include?(startup)
  end

  def team_mate_ids
    self.evo_team? ? self.class.evo_users.pluck(:id) : self.brand_user_ids
  end

  protected

  def password_present?
    password.present?
  end

  def validate_password?
    new_record?
  end

  def skip_confirmation
    self.skip_confirmation!
  end

  def create_favorite_list
    List.create(author: self,
                favorite: true,
                name: 'Favorites')
  end

end
