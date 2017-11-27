class StartupWatcher < ActiveRecord::Base
  belongs_to :user, foreign_key: :watcher_id
  belongs_to :startup
end
