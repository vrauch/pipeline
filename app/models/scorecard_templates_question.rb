class ScorecardTemplatesQuestion < ActiveRecord::Base
  belongs_to :scorecard_template
  belongs_to :question
  accepts_nested_attributes_for :question
end
