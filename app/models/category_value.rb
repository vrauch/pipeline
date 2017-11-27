class CategoryValue < ActiveRecord::Base
  belongs_to :category

  has_many :startup_brief_answers
  has_many :search_categories
end
