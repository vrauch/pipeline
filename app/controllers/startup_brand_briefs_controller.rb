class StartupBrandBriefsController < ApplicationController
  load_and_authorize_resource

  layout 'startup_brief'

  before_action :set_brand, only: [:new, :create]
  before_action :find_startup, only: [:new, :create]
  before_action :check_questions, only: :new
  before_action :check_if_already_passed, only: :new
  before_action :initialize_summary, only: [:new, :create]

  def new
    @brand_questions = @brand.brand_questions
  end

  def create
    startup_brand_brief = StartupBrandBrief.find_or_create_by(startup: @startup, brand: @brand)
    @summary.save_brand_answers(params[:answers], startup_brand_brief.id) if params[:answers].present?
    flash[:notice] = { title: 'Done', text: 'You have successfully submitted this brief' }
    redirect_to home_startup_path(@startup)
  end

  private

  def set_brand
    @brand = Brand.find_by(alias: params[:brand_alias].downcase)
    redirect_to root_path unless @brand
  end

  def check_questions
    unless @brand.brand_questions.any?
      flash[:notice] = { title: 'Notice', text: 'Sorry. Seems there is no questions.' }
      redirect_to home_startup_path(@startup)
    end
  end

  def check_if_already_passed
    if StartupBrandBrief.find_by(startup: @startup, brand: @brand).present?
      flash[:notice] = { title: 'Notice', text: 'You have already submitted this brief' }
      redirect_to home_startup_path(@startup)
    end
  end

  def find_startup
    @startup = current_user.startup
  end

  def initialize_summary
    @summary = StartupBriefSummary.new(startup_id: @startup.id)
  end
end
