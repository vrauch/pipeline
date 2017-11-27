class ScorecardsController < ApplicationController
  load_and_authorize_resource except: [:create, :show_by_token]
  before_action :check_role, only: :create
  before_action :set_scorecard, only: [:show, :refresh_persisted]

  def index
    if current_user && current_user.brand_team?
      @scorecard_templates = current_user.brand.scorecards.sent.includes(:scorecard_template, :user)
    else
      @scorecard_templates = ScorecardTemplate.includes(:brand, scorecards: [:user])
      @scorecard_templates = @scorecard_templates.order_by_scorecards_count
    end
    @drafts = Scorecard.draft if current_user && current_user.evo_team?
    search_scorecard
    if current_user && current_user.brand_team? || @search
      @scorecard_templates = @scorecard_templates.group_by(&:scorecard_template)
    end
    render :index_brand if current_user.brand_team?
  end

  def show
    @scorecard = @scorecard.decorate

    respond_to do |format|
      format.html { render :show, layout: 'application' }
      format.pdf do
        render pdf: "Scorecard #{@scorecard.title}",
               layout: 'layouts/pdf.html',
               show_as_html: params.key?('debug'),
               margin: { top: 10,
                         bottom: 10,
                         left: 15,
                         right: 15 },
                         zoom: 0.64,
              page_size: 'Letter',
              viewport_size: '1280x1024'
      end
    end
  end

  def download_list
    if current_user.try(:brand_team?)
      @scorecard_template = current_user.brand.scorecard_templates.find_by_id(params[:template_id])
      @scorecards = @scorecard_template.scorecards.sent
    else
      if params[:drafts]
        @scorecards = Scorecard.draft
      else
        @scorecard_template = ScorecardTemplate.find_by_id(params[:template_id])
        @scorecards = @scorecard_template.scorecards
      end
    end
    @scorecards = @scorecards.decorate
    render pdf: "Scorecards from #{params[:drafts] ? 'Drafts' : @scorecard_template.title}",
           layout: 'layouts/pdf.html',
           show_as_html: params.key?('debug'),
           margin: { top: 10,
                     bottom: 10,
                     left: 15,
                     right: 15 },
                     zoom: 0.64,
          page_size: 'Letter',
          viewport_size: '1280x1024'
  end

  def generate_pdf
    scorecard_ids = params[:scorecard_ids]
    @scorecards = Scorecard.unscoped.where(id: scorecard_ids).order("field(id, #{scorecard_ids.join(', ')})")
    @scorecards = @scorecards.decorate
    render pdf: "Scorecards",
           layout: 'layouts/pdf.html',
           template: 'scorecards/download_list.pdf',
           show_as_html: params.key?('debug'),
           margin: { top: 10,
                     bottom: 10,
                     left: 15,
                     right: 15 },
                     zoom: 0.64,
          page_size: 'Letter',
          viewport_size: '1280x1024'
  end

  def show_by_token
    @scorecard = Scorecard.find_by(token: params[:token]).try(:decorate)

    respond_to do |format|
      format.html { render :show, layout: 'application' }
      format.pdf do
        render pdf: "Scorecard #{@scorecard.title}",
               template: 'scorecards/show',
               layout: 'layouts/pdf.html',
               margin: { top: 10,
                         bottom: 10,
                         left: 15,
                         right: 15 },
                         zoom: 0.64,
              page_size: 'Letter',
              viewport_size: '1280x1024'
      end
    end
  end

  def new
    session[:scorecard_params] = {}
    session[:scorecard_answers] = {}
    @scorecard = Scorecard.new(session[:scorecard_params])
    @scorecard.current_step = session[:scorecard_step] = nil
    @scorecard.scorecard_template_id = params[:scorecard_template_id]
    @scorecard.startup_id = params[:startup_id]
    step_actions
  end

  def create
    session[:scorecard_params].deep_merge!(scorecard_params) if params[:scorecard]
    session[:scorecard_answers].deep_merge!(params[:scorecard_answers]) if params[:scorecard_answers]
    @scorecard = Scorecard.new(session[:scorecard_params])
    @scorecard.current_step = session[:scorecard_step]
    validate_answers(params[:scorecard_answers])
    if params[:back_button]
      @scorecard.previous_step
    elsif params[:save]
      @scorecard.user_id = current_user.id
      @scorecard.build_answers(session[:scorecard_answers])
      @scorecard.save(validate: false)
      @scorecard.generate_scores!
      flash[:notice] = { title:'Done', text:'Draft successfully saved' }
      render :finalize and return
    elsif params[:preview]
      @is_preview = true
      @scorecard = @scorecard.decorate
      render :preview and return
    elsif @scorecard.valid?
      if @scorecard.last_step?
        @scorecard.build_answers(session[:scorecard_answers])
        @scorecard.validate_all_answers
        @scorecard.user_id = current_user.id
        if @scorecard.all_valid?
          @scorecard.save
          @scorecard.generate_scores!
          @scorecard.complete! if @scorecard.draft?
        end
      else
        @scorecard.next_step
      end
    end
    session[:scorecard_step] = @scorecard.current_step
    step_actions

    if @scorecard.new_record?
      render :new
    else
      session[:scorecard_step] = params[:scorecard_answers] = session[:scorecard_params] = nil
      flash[:notice] = { title:'Done', text:'Scorecard successfully created' }
      respond_to do |format|
        format.html { redirect_to scorecards_path }
        format.js { render :finalize }
      end
    end
  end

  def edit
    @scorecard.current_step = Scorecard::STEPS[1]
    session[:scorecard_params] = {}
    session[:scorecard_step] = @scorecard.current_step
    session[:scorecard_answers] = @scorecard.form_answers
    step_actions
    render :new
  end

  def update
    session[:scorecard_params].deep_merge!(scorecard_params) if params[:scorecard]
    session[:scorecard_answers].deep_merge!(params[:scorecard_answers]) if params[:scorecard_answers]
    @scorecard.current_step = session[:scorecard_step]
    @scorecard.attributes = session[:scorecard_params]
    validate_answers(session[:scorecard_answers])
    if params[:back_button]
      @scorecard.previous_step
    elsif params[:save]
      @scorecard.user_id = current_user.id
      if(session[:scorecard_answers].try(:any?))
        @scorecard.clear_answers!
        @scorecard.build_answers(session[:scorecard_answers])
      end
      @scorecard.save(validate: false)
      @scorecard.generate_scores!
      flash[:notice] = { title:'Done', text:'Scorecard successfully saved' }
      render :finalize and return
    elsif params[:preview]
      @is_preview = true
      @scorecard = @scorecard.decorate
      render :preview and return
    elsif  @scorecard.valid?
      if @scorecard.last_step?
        if all_answers_params_is_valid?(session[:scorecard_answers])
          @scorecard.clear_answers!
          @scorecard.build_answers(session[:scorecard_answers])
          @scorecard.validate_all_answers
          @scorecard.user_id = current_user.id
          if @scorecard.all_valid?
            @scorecard.save
            @scorecard.generate_scores!
            @scorecard.complete! if @scorecard.draft?
            flash[:notice] = { title:'Done', text:'Scorecard successfully saved' }

            render :finalize and return
          end

        end
      else
        @scorecard.next_step
      end
    end
    step_actions

    session[:scorecard_step] = @scorecard.current_step
    render :new
  end

  def destroy
    @scorecard_id = @scorecard.id
    if @scorecard.destroy
      flash[:notice] = { title: 'Done',
                             text: 'Scorecard successfully deleted' }
      redirect_to scorecards_path
    end
  end


  def cancel
    session[:scorecard_step] = session[:scorecard_params] = nil
    respond_to do |format|
      format.html { redirect_to scorecards_path }
      format.js
    end
  end

  def refresh
    @scorecard = Scorecard.new(scorecard_params)
    @scorecard.startup_id = session[:scorecard_params]['startup_id']
    @scorecard.scorecard_template_id = session[:scorecard_params]['scorecard_template_id']
    @scorecard.current_step = session[:scorecard_step]
    step_actions
  end

  def refresh_persisted
    @scorecard.assign_attributes(scorecard_params)
    @scorecard.startup_id = session[:scorecard_params]['startup_id'] if session[:scorecard_params]['startup_id']
    @scorecard.scorecard_template_id = session[:scorecard_params]['scorecard_template_id'] if session[:scorecard_params]['scorecard_template_id']
    @scorecard.current_step = session[:scorecard_step]
    step_actions
    render :refresh
  end

  def push
    @scorecard = Scorecard.find_by(id: params[:scorecard_id])
    if @scorecard.draft?
      flash[:error] = { title:'Error', text:'You must complete scorecard!' }

      render :notification and return
    end

    @scorecard.sent!
    @scorecard = @scorecard.decorate
    flash.now[:notice] = {
      title:'SCORECARD SUCCESSFULLY PUSHED',
      text: 'Brand users will receive a notification'
    }
    ActivityService.new(current_user).send_scorecard(@scorecard)
    render :update
  end

  def search_startups
    if params[:search]
      @startups = Startup.all_startups(current_user).search_by_title(params[:search])
        .order(created_at: :desc).limit(25)
    else
      @startups = Startup.all_startups(current_user).order(created_at: :desc)
        .limit(25)
    end
  end

private

  def brand_scorecards_params
    params.require(:brand_scorecard).permit(:brand_id)
  end

  def set_scorecard
    @scorecard = Scorecard.find_by_id(params[:id])
  end

  def step_actions
    case @scorecard.current_step
    when 'template'
      @scorecard_templates = ScorecardTemplate.all.order_by_created_date
      @startups = Startup.all_startups(current_user).order(created_at: :desc).limit(25)
      if action_name == 'create'
        session[:scorecard_params] = {}
        session[:scorecard_answers] = {}
      end
    when 'overview'
      @scorecard.build_from_startup if action_name == 'create' && params[:back_button].nil?
      @scorecard = @scorecard.decorate
    when 'product'
      @scorecard_questions = Question.default
        .from_product(@scorecard.scorecard_template.startup_model)
        .includes(:variants)
    when 'collaboration'
      @scorecard_questions = Question.default
        .from_collaboration(@scorecard.scorecard_template.startup_model)
        .includes(:variants)
    when 'business'
      @scorecard_questions = @scorecard.scorecard_template.questions.includes(:variants)
    when 'recommendation'
      @scorecard = @scorecard.decorate
    end
  end

  def scorecard_params
    params.require(:scorecard).permit(
      :scorecard_template_id,
      :startup_id,
      :title,
      :description,
      :website,
      :date_founded,
      :dev_stage,
      :fun_stage,
      :brand_experience,
      :logo,
      :logo_cache,
      :location,
      :problem_startup_solves,
      :product_image,
      :product_image_cache,
      :product_image_title,
      :rs_product_image,
      :rs_product_image_cache,
      :rs_product_image_title,
      :how_it_works,
      :micro_trends,
      :macro_trends,
      :recommendation
    )
  end

  def search_scorecard
    @search = params[:search]
    if @search
      if current_user && current_user.brand_team?
        @scorecard_templates = @scorecard_templates.search_by_title(@search)
      else
        @scorecard_templates = Scorecard.includes(:user, scorecard_template: [])
          .search_by_title(@search)
      end
      @drafts = @scorecard_templates.draft if current_user && current_user.evo_team?
    end
  end

  def validate_answers(answers)
    if Scorecard::STEPS[2..4].include?(@scorecard.current_step)
      size = Variant.where(id: answers.try(:values))
        .get_by_types(@scorecard.current_step, @scorecard.scorecard_template.startup_model)
        .count
      @scorecard.answers_quantity = answers.nil? ? 0 : size
    end
  end

  def all_answers_params_is_valid?(params)
    is_valid = true
    Scorecard::STEPS[2..4].each do |step|
      size = Variant.where(id: params.try(:values))
        .get_by_types(step, @scorecard.scorecard_template.startup_model).count
      is_valid = false if params.nil? || size != 5
    end
    is_valid
  end

  # because load_and_authorize_resource need params
  def check_role
    redirect_to root_path unless current_user && current_user.evo_team?
  end
end
