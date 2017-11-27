class StartupNote < ActiveRecord::Base
  belongs_to :startup
  belongs_to :note
end
