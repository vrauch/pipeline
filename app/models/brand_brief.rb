class BrandBrief < ActiveRecord::Base
  belongs_to :brand
  belongs_to :submitter, class_name: 'User'
  has_many   :brief_summaries, class_name: 'BrandBriefSummary'

  validates :brand_id, presence: true, uniqueness: true
end
