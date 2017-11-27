class BrandPackage < ActiveRecord::Base
  belongs_to :brand
  belongs_to :package

  scope :active_package, -> { where(active: true) }

  # scope :life_supporting, where('distance_from_sun > ?', 5).order('diameter ASC')
end
