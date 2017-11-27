class BrandBriefQuestion < ActiveRecord::Base

  has_many :answers, class_name: 'BrandBriefAnswer', foreign_key: :brief_question_id

  enum question_type: [:single, :multi, :text]
end
