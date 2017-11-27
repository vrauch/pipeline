class DiagnosticQuestion < ActiveRecord::Base

  has_many :answers, class_name: 'DiagnosticAnswer', foreign_key: 'question_id'

  validates :question_text, presence: true

  accepts_nested_attributes_for :answers
end
