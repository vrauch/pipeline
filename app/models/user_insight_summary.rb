class UserInsightSummary < ActiveRecord::Base

  belongs_to :insight_group
  belongs_to :diagnostic_type

  scope :insight_alias, -> (insight_alias) do
    joins(:insight_group).where(insight_groups: { alias: insight_alias }).first
  end

end
