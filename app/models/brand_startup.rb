class BrandStartup < ActiveRecord::Base
  belongs_to :brand, counter_cache: true
  belongs_to :startup

  validates_uniqueness_of :startup_id, scope: [:brand_id]
  validates :startup, presence: true
end
