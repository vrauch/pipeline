class ListStartup < ActiveRecord::Base
  belongs_to :list
  belongs_to :startup

  validates_uniqueness_of :startup_id, scope: [:list_id]
end
