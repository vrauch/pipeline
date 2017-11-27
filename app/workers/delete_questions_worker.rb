class DeleteQuestionsWorker
  include Sidekiq::Worker
  def perform
    ids =  ScorecardTemplatesQuestion.pluck(:question_id).uniq
    Question.custom.where.not(id: ids).destroy_all
  end
end
