class StartupPromoBriefsController < ApplicationController
  layout 'startup_brief'

  before_action :set_promo_page, only: [:new, :create]
  before_action :find_startup, only: [:new, :create]
  before_action :check_questions, only: :new
  before_action :check_if_already_passed, only: :new
  before_action :initialize_summary, only: [:new, :create]
  after_action  :submitting_brief_activity, only: [:create]


  def new
    @promo_questions = @promo.promo_page_questions
  end

  def create
    @summary.save_promo_answers(params[:answers]) if params[:answers].present?
    flash[:notice] = { title: 'Done', text: 'You have successfully submitted this brief' }
    redirect_to home_startup_path(@startup)
  end

  private

  def set_promo_page
    @promo = PromoPage.includes(:promo_page_questions).find_by(alias: params[:promo_alias].downcase)
  end

  def find_startup
    @startup = current_user.startup
  end

  def initialize_summary
    @summary = StartupBriefSummary.new(startup_id: @startup.id)
  end

  def check_questions
    unless @promo.promo_page_questions.any?
      flash[:notice] = "Sorry. Seems that there's no questions."
      redirect_to home_startup_path(@startup)
    end
  end

  def check_if_already_passed
    promo_brief = StartupPromoBrief.select(:id).find_by(startup: @startup, 
                                                        promo_page: @promo)
    already_passed = StartupBriefSummary.where(startup_promo_brief_id: promo_brief.id).any? if promo_brief
    if already_passed
      flash[:notice] = 'You have already submitted this brief'
      redirect_to home_startup_path(@startup)
    end
  end

  def submitting_brief_activity
    activity = Activity.find_by(alias: 'startup_filled_in_brand_profile')
    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{brand_name}}'],
                                   replacements: [@promo.brand_title])

    user_activity = UserActivity.create(user: current_user, activity: activity,
                                        resource_id: @startup.id,
                                        resource_type: UserActivity.resource_types[:startup],
                                        evo_text: texts[:evo], brand_text: texts[:brand])

    EvoMailer.notification(user_activity, 'Startup Completed Profile').deliver_now
    BrandMailer.startup_filled_in_profile(user_activity, @promo.brand).deliver_now
  end
end
