class StartupPromoBrief < ActiveRecord::Base

  belongs_to :startup
  belongs_to :promo_page, unscoped: true

  validates_uniqueness_of :startup_id, scope: [:promo_page_id]
end
