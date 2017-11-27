class UserDiagnosticSummary < ActiveRecord::Base

  LETTERS = ('a'..'e').to_a

  validates :user_id,   presence: true
  validates :answer_id, presence: true,
                        numericality: true
end
