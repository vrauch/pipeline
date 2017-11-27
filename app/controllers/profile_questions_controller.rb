class ProfileQuestionsController < ApplicationController
  # load_resource :startup
  # load_and_authorize_resource :startup_profile_question, through: :startup

  after_action :evo_sent_question_to_startup, only: [:create]
  after_action :startup_answered_to_evo, only: [:update]

  def new
    @profile_question = StartupProfileQuestion.new
  end

  def create
    @startup = Startup.find_by(id: params[:startup_id]) if params[:startup_id].present?
    params[:startup_profile_question][:user_id] = current_user.id
    params[:startup_profile_question][:startup_id] = params[:startup_id]
    @profile_question = StartupProfileQuestion.new(question_params)
    if @profile_question.save
      flash.now[:notice] = { title: 'Question sent', 
                             text: 'You\'ll be notified, when startup will answer' }
    end 
  end

  def update
    @profile_question = StartupProfileQuestion.find_by(id: params[:id])
    @profile_question.update(question_params)
    @startup = @profile_question.startup
    @profile_questions = @startup.profile_questions.includes(:user, :answer)
                                                   .order(:answered)
  end

  private

  def evo_sent_question_to_startup
    return false unless @profile_question.valid?
    activity = Activity.find_by(alias: 'evo_sent_question_to_startup')
    texts = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern],
                                               startup: activity[:startup_pattern] },
                                   replaces: ['{{user_name}}', '{{question_text}}', '{{startup_name}}'],
                                   replacements: [current_user.full_name, @profile_question.body, @profile_question.startup.title])

    user_activity = UserActivity.create(user: current_user, activity: activity,
                                        evo_text: texts[:evo], startup_text: texts[:startup],
                                        resource_type: UserActivity.resource_types[:startup],
                                        resource_id: @startup.id, evo_logo: true)

    EvoMailer.notification(user_activity, 'Evo sent question to startup').deliver_now
    StartupMailer.question_sent(user_activity, @profile_question).deliver_now
  end

  def startup_answered_to_evo
    return false unless @profile_question.valid?
    activity = Activity.find_by(alias: 'startup_answered_to_evo')
    texts = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern] },
                                   replaces: ['{{startup_name}}', '{{question_text}}', '{{answer_text}}'],
                                   replacements: [@startup.title, @profile_question.body, @profile_question.answer.body])

    user_activity = UserActivity.create(user: current_user, activity: activity, evo_text: texts[:evo],
                                        resource_type: UserActivity.resource_types[:startup],
                                        resource_id: @startup.id)

    EvoMailer.notification(user_activity, 'Startup answered on question').deliver_now
  end

  def question_params
    params.require(:startup_profile_question).permit(:id, :title, :body, 
                                                     :startup_id, :user_id,
                                                     :answered, 
                                                     answer_attributes: [ :id, 
                                                                          :body])
  end
end
