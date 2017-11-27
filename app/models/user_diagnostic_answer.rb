class UserDiagnosticAnswer < ActiveRecord::Base

  attr_accessor :question_id

  belongs_to :user
  belongs_to :answer, class_name: 'DiagnosticAnswer'

  validates :answer_id, presence: true,
                        numericality: true
end
