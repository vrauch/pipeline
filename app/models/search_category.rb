class SearchCategory < ActiveRecord::Base
  belongs_to :search
  belongs_to :category_value
end
