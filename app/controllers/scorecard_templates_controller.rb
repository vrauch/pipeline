class ScorecardTemplatesController < ApplicationController
  load_and_authorize_resource except: :create
  before_action :check_role, only: :create
  before_action :set_scorecard_template, only: [:show, :edit, :destroy, :refresh_persisted]
  before_action :can_edit, only: [:edit]

  def index
    @scorecard_templates = ScorecardTemplate.order_by_created_date.includes(:brand, :user)
  end

  def show
  end

  def generate_xls
    @scorecard_template = ScorecardTemplate.find_by_id(params[:scorecard_template_id])
    file_contents = @scorecard_template.try(:create_scorecards_xls)
    send_data file_contents.string.force_encoding('binary'),
              filename: "#{@scorecard_template.title} scorecards.xls"
  end

  def new
    session[:scorecard_template_params] = {}
    @scorecard_template = ScorecardTemplate.new(session[:scorecard_template_params])
    @scorecard_template.current_step = session[:scorecard_template_step] = nil
    business_actions
    build_new_question
  end

  def edit
    # session[:edit_scorecard_template_params] = @scorecard_template.attributes
    @scorecard_template.current_step = ScorecardTemplate::STEPS.first
    session[:edit_scorecard_template_params] = {}
    session[:edit_scorecard_template_step] = @scorecard_template.current_step
    render :new
  end

  def create
    check_startup_model_changes(session[:scorecard_template_params])
    session[:scorecard_template_params].deep_merge!(scorecard_template_params.except(:question)) if params[:scorecard_template]
    @scorecard_template = ScorecardTemplate.new(session[:scorecard_template_params])
    @scorecard_template.current_step = session[:scorecard_template_step]
    if params[:back_button]
      @scorecard_template.previous_step
    elsif params[:select_brand]
    elsif params[:add_question]
      add_question
      render :new and return
    elsif @scorecard_template.valid?
      if @scorecard_template.last_step?
        @scorecard_template.save if @scorecard_template.all_valid? && select_questions
      else
        @scorecard_template.next_step
      end
    end
    session[:scorecard_template_step] = @scorecard_template.current_step
    business_actions
    build_new_question
    if @scorecard_template.new_record?
      render :new
    else
      session[:scorecard_template_step] = session[:scorecard_template_params] = nil
      flash.now[:notice] = { title:'Done', text:'Template successfully saved' }

      render :finalize
    end
  end

  def update
    # check_startup_model_changes(session[:edit_scorecard_template_params])
    session[:edit_scorecard_template_params].deep_merge!(scorecard_template_params.except(:question)) if params[:scorecard_template]
    @scorecard_template.current_step = session[:edit_scorecard_template_step]
    @scorecard_template.attributes = session[:edit_scorecard_template_params]
    if params[:back_button]
      @scorecard_template.previous_step
    elsif params[:add_question]
      add_question
      render :new and return
    elsif  @scorecard_template.valid?
      if @scorecard_template.last_step?
        @scorecard_template.save if @scorecard_template.all_valid? && select_questions
        session[:edit_scorecard_template_step] = nil
        session[:edit_scorecard_template_params] = nil
        flash.now[:notice] = { title:'Done', text:'Template successfully saved' }
        render :show and return
      else
        @scorecard_template.next_step
        questions_for_edit if @scorecard_template.questions.size <= 5
      end
    end
    build_new_question if @scorecard_template.current_step == 'business'
    session[:edit_scorecard_template_step] = @scorecard_template.current_step
    render :new
  end

  def destroy
    if @scorecard_template.destroy
      flash[:notice] = { title: 'Done',
                             text: 'Template successfully deleted' }
      redirect_to scorecard_templates_path
    end
  end

  def cancel
    session[:scorecard_template_step] = session[:scorecard_template_params] = nil
    respond_to do |format|
      format.html { redirect_to scorecards_path }
      format.js { (set_scorecard_template; render :show) if params[:id].present? }
    end
  end

  def refresh
    @scorecard_template = ScorecardTemplate.new(scorecard_template_params)
    @scorecard_template.current_step = session[:scorecard_template_step]
  end

  def refresh_persisted
    @scorecard_template.attributes = scorecard_template_params
    @scorecard_template.current_step = session[:scorecard_template_step]
    render :refresh
  end

  private

  def add_question
    # business_actions
    @scorecard_template.questions.build(question_params)

    build_new_question
  end

  def set_scorecard_template
    @scorecard_template = ScorecardTemplate.find_by_id(params[:id])
  end

  def business_actions
    if @scorecard_template.current_step == 'business'
      if @scorecard_template.questions.empty?
        @business_questions = Question.default.from_business(@scorecard_template.startup_model).includes(:variants)
        @scorecard_template.build_questions_from(@business_questions)
      end
    end
  end

  def build_new_question
    if @scorecard_template.current_step == 'business'
      @new_question = Question.new()
      @new_question.variants.build(score: 0)
      @new_question.variants.build(score: 1)
      @new_question.variants.build(score: 2)
    end
  end

  def questions_for_edit
    if @scorecard_template.current_step == 'business'
      default_titles = @scorecard_template.questions.pluck('title')
      @business_questions = Question.default
        .from_business(@scorecard_template.startup_model)
        .where.not(title: default_titles).includes(:variants)
      @scorecard_template.build_questions_from(@business_questions)
    end
  end

  def select_questions
    @scorecard_template.questions.each do |q|
      @scorecard_template.questions.delete(q) if q.is_selected == '0'
    end
  end

  # for new scorecard template if user change startup model (b2b or b2c)
  def check_startup_model_changes(session_params)
    unless params[:back_button] || session[:scorecard_template_step] == ScorecardTemplate::STEPS.last
      prev_s_model = session_params.try(:[], 'startup_model')
      current_s_model = scorecard_template_params.try(:[], :startup_model)
      if prev_s_model.to_s != current_s_model.to_s
        params[:startup_model_changed] = true
        session_params['questions_attributes'] = []
      end
    end
  end

  def scorecard_template_params
    params.require(:scorecard_template).permit(
      :title_brand,
      :title_brief,
      :title_year,
      :macro_categories_title,
      :micro_categories_title,
      :ls_product_section_type,
      :rs_product_section_type,
      :scorecard_type,
      :startup_model,
      :logo,
      :logo_cache,
      :brand_id,
      question: [
        :body,
        variants_attributes: [
          :score, :title
        ]
      ],
      questions_attributes: [
        :id,
        :title,
        :body,
        :is_selected,
        :score_type,
        :question_for,
        :question_type,
        variants_attributes: [
          :id,
          :score, :title
        ]
      ]
    ).merge(user_id: current_user.id)
  end

  def update_scorecard_template_params
    scorecard_template_params.merge(questions_attributes: [
      :id,
      variants_attributes: [:id]
    ])
  end

  def question_params
    params.require(:scorecard_template).require(:question).permit(
      :body,
      variants_attributes: [
        :score, :title
      ]
    ).merge(score_type: :business,
          question_for: :scorecards,
         question_type: :any)
  end

  # because load_and_authorize_resource need params
  def check_role
    redirect_to root_path unless current_user && current_user.evo_team?
  end

  def can_edit
    render :show unless @scorecard_template.can_edit?
  end
end
