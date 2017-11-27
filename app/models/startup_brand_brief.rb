class StartupBrandBrief < ActiveRecord::Base
  belongs_to :startup
  belongs_to :brand
  
  validates_uniqueness_of :startup_id, scope: [:brand_id]
end
