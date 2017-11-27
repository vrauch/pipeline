class ScorecardAnswer < ActiveRecord::Base
  belongs_to :scorecard
  belongs_to :variant
  accepts_nested_attributes_for :variant
end
