class StartupBriefSummariesController < ApplicationController
  layout 'startup'
  before_action :find_startup, only: [:new, :create, :to_step]
  before_action :initialize_summary, only: [:new, :create, :to_step]
  before_action :previous_brief, only: [:create]
  after_action :save_activity, only: [:create]

  def new
    step = 1
    @questions = StartupBriefQuestion.preload(:answers, answers: [:category_value])
                                     .step(step).order(:question_order)
    @answers = @startup.startup_brief_summaries.main_brief
                                               .any? ? @startup.form_answers_result(step) : {}
  end

  def create
    step = params[:startup_brief_summary][:progress_step].to_i
    next_step = step + 1

    @summary.save_answers(params[:answers]) if params[:answers]
    @summary.save_promo_answers(params[:promo_answers]) if params[:promo_answers]

    if step == 4 && !current_user.active?
      current_user.update_attribute(:active, 1)
      flash[:notice] = { title: 'Done', text: 'Congratulations, you have completed your profile' }
      startup_filled_in_profile_activity
    end

    @startup.update(startup_params) if params[:startup].present?

    @questions = StartupBriefQuestion.preload(:answers, answers: [:category_value])
                                     .step(next_step).order(:question_order)

    if @startup.promo_pages.any? && next_step == 4
      @promo_answers = @startup.startup_brief_summaries.promo_brief
                                                       .any? ? @startup.form_promo_results : {}
    end


    @answers = @startup.startup_brief_summaries.main_brief
                                               .any? ? @startup.form_answers_result(next_step) : {}

    if current_user.active?
      flash[:notice] = { title: 'Done', text: 'Changes were saved successfully' }
    end
  end

  def to_step
    @step = params[:back].present? ? params[:progress_step].to_i - 1
                                   : params[:progress_step].to_i

    @questions = StartupBriefQuestion.preload(:answers, answers: [:category_value])
                                     .step(@step).order(:question_order)

    if @startup.promo_pages.any? && @step == 4
      @promo_answers = @startup.startup_brief_summaries.promo_brief
                                                       .any? ? @startup.form_promo_results : {}
    end

    @answers = @startup.startup_brief_summaries.main_brief
                                               .any? ? @startup.form_answers_result(@step) : {}
    render 'create'
  end

  def update
  end

  private

  def startup_params
    params.require(:startup).permit(:share_info, :receive_emails)
  end

  def find_startup
    @startup = Startup.includes(:startup_brief_summaries)
                      .find_by(id: params[:startup_id])
  end

  def initialize_summary
    @summary = StartupBriefSummary.new(startup_id: @startup.id)
  end

  def previous_brief
    @previous_brief = StartupBriefSummary.brief_values(@startup.startup_brief_summaries
                                                               .main_brief)
  end

  def startup_filled_in_profile_activity
    if @startup.promo_pages.any?
      action_alias = 'startup_filled_in_brand_profile'
      brand = @startup.promo_pages.first.brand
      brand_title = brand.title
    else
      action_alias = 'startup_filled_in_evo_profile'
      brand, brand_title = nil, ''
    end


    activity = Activity.find_by(alias: action_alias)
    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{startup_name}}', '{{brand_name}}'],
                                   replacements: [@startup.title, brand_title ])

    user_activity = UserActivity.create(user: current_user, activity: activity,
                        resource_id: @startup.id,
                        resource_type: UserActivity.resource_types[:startup],
                        evo_text: texts[:evo], brand_text: texts[:brand])

    EvoMailer.notification(user_activity, 'Startup Completed Profile').deliver_now
    if @startup.promo_pages.any?
      BrandMailer.startup_filled_in_profile(user_activity, brand).deliver_now
    end
  end

  def save_activity
    @current_brief = StartupBriefSummary.brief_values(@startup.startup_brief_summaries
                                                              .main_brief)

    updated = []
    @current_brief.each do |question_id, brief|
      if brief != @previous_brief[question_id]
        current_value = StartupBriefSummary.prepare_value(brief[:value])
        previous_value = @previous_brief[question_id] ? StartupBriefSummary.prepare_value(@previous_brief[question_id][:value]) : 'none specified'
        updated << "'#{brief[:category]}' from '#{previous_value}' to '#{current_value}'"
      end
    end

    if updated.any? && current_user.active?
      activity = Activity.find_by(alias: 'startup_edited_brief')

      texts = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern] },
                                     replaces: ['{{startup_name}}', '{{updates}}'],
                                     replacements: [current_user.full_name, updated.join(';<br>')])

      UserActivity.create(user: current_user, activity: activity, evo_text: texts[:evo],
                          resource_id: @startup.id,
                          resource_type: UserActivity.resource_types[:startup])
    end

  end
end
