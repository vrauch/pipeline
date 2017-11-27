class IndexWorker
  include Sidekiq::Worker
  def perform()
    `rake ts:index`
  end
end
