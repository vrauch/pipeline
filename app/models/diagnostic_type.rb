class DiagnosticType < ActiveRecord::Base
  validates :title,       presence: true
  validates :description, presence: true
  validates :points_from, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :points_to,   presence: true,
                          numericality: { greater_than_or_equal_to: 0 }

  has_many :user_insight_summaries

  def initial
    title[0, 1]
  end

end
