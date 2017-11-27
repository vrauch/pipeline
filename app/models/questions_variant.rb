class QuestionsVariant < ActiveRecord::Base
  belongs_to :question
  belongs_to :variant, dependent: :destroy
  accepts_nested_attributes_for :variant
end
