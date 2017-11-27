# Package model class
class Package < ActiveRecord::Base
  has_many :brand_packages, -> { where active: true }
  has_many :brands, through: :brand_packages
  
  validates :name, presence: true
  validates :number_brand_briefs,
            :number_external_pages,
            :number_questions,
            :number_startups,
            :number_scorecards,
            :number_scorecard_requests,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :number_users,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            unless: 'unlimited_users'

  acts_as_paranoid
end
