class DiagnosticAnswer < ActiveRecord::Base
  belongs_to :question, class_name: 'DiagnosticQuestion'

  validates :answer_text,   presence: true
  validates :number_points, presence: true,
                            numericality: true

end
