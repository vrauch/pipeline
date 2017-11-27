class Activity < ActiveRecord::Base
  has_many :user_activities

  delegate :photo, to: :user, prefix: true
  delegate :full_name, to: :user, prefix: true

  class << self

    def prepare_texts(data)
      results = {}
      data[:patterns].each do |key, pattern|
        next unless pattern
        results[key] = pattern
        data[:replaces].each_with_index do |replace, i|
          results[key].gsub!(replace, data[:replacements][i])
        end
      end
      results
    end
  end
end
