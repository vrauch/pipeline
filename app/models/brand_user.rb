class BrandUser < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :brand, counter_cache: true
  belongs_to :user
end
