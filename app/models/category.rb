class Category < ActiveRecord::Base
  has_many :category_values
  scope :answers_for, ->(category_name) { find_by("name LIKE ?", 
                                                  "%#{category_name}%")
                                          .category_answers
                                          .pluck(:id) }
end
