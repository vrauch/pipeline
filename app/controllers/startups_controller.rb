class StartupsController < ApplicationController
  include ApplicationHelper
  include StartupsHelper

  helper_method :sort_column, :sort_direction

  before_action :find_startup, only: [:show, :profile, :home, :questions,
                                      :new_push, :create_push, :all_questions,
                                      :new_add_to_list, :add_to_list, :cabinet,
                                      :requests, :tags, :activity, :delete,
                                      :destroy, :notes, :tasks]
  before_action :find_startup_brand, only: [:profile, :questions, :requests,
                                            :activity, :notes, :tasks,
                                            :update, :update_watchlist]

  load_and_authorize_resource

  before_action :find_favorite_list, only: [:create, :index, :watchlist]
  before_action :form_summary, only: [:profile, :show, :cabinet]
  before_action :form_promo_results, only: [:profile, :show, :cabinet]
  before_action :form_brand_results, only: [:profile, :show, :cabinet]
  before_action :get_startup_tags, only: [:show, :profile, :questions, :notes,
                                          :requests]
  before_action :set_gon, only: [:profile, :questions, :requests, :notes, :show,
                                 :activity]
  before_action :set_startup, only: [:add_pdf, :destroy_pdf, :cancel]
  after_action :pushing_startup_activity, only: [:create_push]
  after_action :set_download_startup_ids, only: [:index, :watchlist, :search]
  after_action :pdf_after_cancel_actions, only: [:cancel, :cabinet]
  skip_before_action :clear_search_session, only: [:questions, :notes, :tasks, :activity]
  layout :resolve_layout

  def new
    session[:startup_params], session[:startup_step] = {}, nil
    session[:brief_params] = {}
    @startup = Startup.new.decorate
    if params[:full_profile]
      render 'new_full_profile'
    end
  end

  def create
    @startups, @startup_tags = [], {}
    if params[:full_profile]
      create_by_evo
    else
      @startup = Startup.new(startup_params)
      if @startup.save
        StartupService.new(@startup).creating_watchlist_activity(current_user)
        flash.now[:notice] = { title: 'Done', text: 'Startup added to your watchlist.' }
      end
    end
  end

  def create_by_evo
    params_startup = params[:startup] ? startup_params : session[:startup_params]
    session[:brief_params].deep_merge!(params[:brief_answers]) if params[:brief_answers]
    @startup = Startup.new(params_startup).decorate
    @startup.current_step = session[:startup_step]

    session[:startup_params] = create_session_params if params[:startup]

    if @startup.valid?
      if params[:back_button]
        @startup.previous_step
      elsif @startup.last_step?
        StartupService.new(@startup).create_full_profile(session[:brief_params])
        flash.now[:notice] = { title: 'Done', text: 'Startup has been created successful' }
      else
        @startup.next_step
      end
      session[:startup_step] = @startup.current_step
    end
    brief_questions

    render 'create_by_evo'
  end

  def edit
    @startup = Startup.includes(:founders).find_by(id: params[:id]).decorate

    if current_user.startup?
      render layout: 'startup'
    else
      session[:startup_params], session[:startup_step] = {}, nil
      session[:brief_params] = @startup.brief_summary
    end
  end

  def update
    if current_user.startup?
      update_by_startup
    else
      update_by_evo
      render 'update_by_evo'
    end
  end

  def update_by_evo
    params_startup = params[:startup] ? startup_params : session[:startup_params]
    session[:brief_params].deep_merge!(params[:brief_answers]) if params[:brief_answers]

    @startup = Startup.find_by(id: params[:id]).decorate
    @startup.attributes = params_startup
    @startup.current_step = session[:startup_step]

    session[:startup_params] = create_session_params if params[:startup]

    if @startup.valid?
      if params[:back_button]
        @startup.previous_step
      elsif @startup.last_step? || params[:save_button]
        StartupService.new(@startup).update_full_profile(session[:startup_params],
                                               session[:brief_params])
        form_summary
        pdf_after_save_actions
        flash.now[:notice] = { title: 'Done', text: 'Startup has been updated successful' }
      else
        @startup.next_step
      end
    end
    session[:startup_step] = @startup.current_step

    brief_questions
  end

  def update_by_startup
    @startup = Startup.includes(:startup_brief_summaries).find_by(id: params[:id])
    current_user.update(user_params) if params[:user].present?
    if @startup.update_attributes(startup_params)
      StartupService.new(@startup).updating_profile_activity(current_user) if current_user.active?
      flash[:notice] = { title: 'Done', text: 'Changes were saved successfully' }
    end
    unless current_user.active?
      step = 1
      @questions = StartupBriefQuestion.preload(:answers, answers: [:category_value])
                                       .step(step).order(:question_order)
      @summary = StartupBriefSummary.new(startup_id: @startup.id)
      @answers = @startup.startup_brief_summaries.where(
          startup_promo_brief_id: nil,
          startup_brand_brief_id: nil).any? ? @startup.form_answers_result(step) : {}
    end
    pdf_after_save_actions
  end

  def show
    if current_user.brand_team?
      @startup_pushed = @startup.brand_startups.where(brand_id: current_user.brand.id).first
    end
  end

  def edit_watchlist
    @startup = Startup.includes(:founders, :watchers).find_by(id: params[:id])
  end

  def update_watchlist
    @startup = Startup.includes(:startup_brief_summaries)
                      .find_by(id: params[:id])
    if @startup.update_attributes(watchlist_params)
      StartupService.new(@startup).updating_watchlist_activity(current_user)
      flash.now[:notice] = { title:'Done', text:'Changes were saved successfully' }
    end
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  def index
    if params[:type] && Startup::STARTUP_TYPES.include?(params[:type])
      sort_column_fn = current_user.brand_team? && params[:type] == Startup::EVOLUTION ? sort_column_for_brand : "startups.#{sort_column}"

      @startups = Startup.preload(:brand_startups, :invite, :promo_briefs, owner: [{ invite: [:sender] }])
                         .page(params[:page])
                         .public_send("#{params[:type]}_confirmed", current_user)
                         .order(sort_column_fn + " " + sort_direction)
    else
      sort_column_fn = current_user.brand_team? ? sort_column_for_brand : "startups.#{sort_column}"
      @startups = Startup.preload(:brand_startups, :invite, :promo_briefs, owner: [{ invite: [:sender] }])
                         .all_startups(current_user)
                         .page(params[:page])
                         .order(sort_column_fn + " " + sort_direction)
    end

    @startups = @startups.unconfirmed if params[:unconfirmed]

    @startup_tags = StartupTag.startup_tags(@startups.pluck(:id), current_user.team_mate_ids)
  end

  def profile
    if current_user.evo_team?
      @scorecards = @startup.scorecards
    elsif current_user.brand_team?
      @scorecards = current_user.brand.scorecards.sent.where(startup_id: @startup.id)
    end
    session[:back_referer] = nil
    urls = [profile_startup_url(@startup),
            questions_startup_url(@startup),
            notes_startup_url(@startup),
            tasks_startup_url(@startup),
            activity_startup_url(@startup)]

    unless urls.include?(request.referer) || params[:skip_back_referer]
      if session[:search_back] && request.referer && request.referer.exclude?('back_search')
        request.referer << (request.referer.include?('?') ? '&' : '?') + 'back_search=true'
      end
      session[:back_referer] = request.referer
    end
  end

  def questions
    @profile_questions = @startup.profile_questions.includes(:user, :answer)
                                                   .order(created_at: :desc)
  end

  def home
    @profile_questions = @startup.profile_questions.includes(:user, :answer)
                                                   .order(:answered).limit(5)
    @questions_count = @startup.profile_questions.includes(:user, :answer)
                                                   .order(:answered).count

    @m_mvs = Announcement.user_announcement(current_user).count
    @announcements = Announcement.user_announcement(current_user).limit(2)
  end

  def all_questions
    @questions = @startup.profile_questions.includes(:user, :answer)
                                           .order(:answered)
  end

  def watchlist
    @startups = Startup.preload(:promo_briefs, :invite, owner: [{ invite: [:sender] }])
                       .page(params[:page])
                       .watchlist(current_user)
                       .order("startups.#{sort_column}" + " " + sort_direction)

    @startup_tags = StartupTag.startup_tags(@startups.pluck(:id), current_user.team_mate_ids)
  end

  def notes
    @notes = NoteDecorator.decorate_collection(
        @startup.notes.preload(:author, :comments, :startup)
            .where(author_id: current_user.team_mate_ids)
            .order(created_at: :desc))
  end

  def tasks
    @tasks = NoteDecorator.decorate_collection(
        @startup.tasks.preload(:author, :assignee, :comments, :startup)
            .where(author_id: current_user.team_mate_ids)
            .order(created_at: :desc))
  end

  # This method is for brand users to see their requests that are related to this
  # startup
  def requests
    @requests = @startup.requests.startup_related_requests(current_user.brand_id)
                                 .order(created_at: :desc)
  end

  def activity
    @activities = @startup.activities.order(created_at: :desc)
  end

  def new_push
    @brands = Brand.preload(:package).all
    @startup_brands_ids = @startup.brand_startups.pluck(:brand_id)
  end

  def create_push
    @startup = Startup.find_by(id: params[:startup_id])
    @brand = Brand.find_by(id: brand_startups_params[:brand_id])

    @brand_startup = @startup.brand_startups.create(brand_startups_params)

    StartupProfileQuestion.send_request(user: current_user,
                                        brand: @brand,
                                        startup: @startup,
                                        link: new_startup_brand_brief_url(brand_alias: @brand.alias))

    flash.now[:notice] = { title:'Done', text:'Startup was successfully pushed' }


    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  def new_add_to_list
    @lists = List.team_lists(current_user)
    @startup_lists = @startup.lists.pluck(:id)
  end

  def create_add_to_list
    @startup = Startup.find_by(id: params[:startup_id])
    @startup.list_startups.create(list_startups_params)
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
    flash.now[:success] = { title: 'Done',
                            text: 'Successfully added.' }
  end

  def search
    @brand = Brand.find_by(id: params[:brand_id])
    @startups = Startup.where('title LIKE ?', "%#{search_params[:query]}%")
    @pushed_startups_ids = @brand.brand_startups.pluck(:startup_id)
  end

  def download
    file_contents = Startup.create_xls(params[:type],
                                       current_user,
                                       session[:download_startup_ids])
    send_data file_contents.string.force_encoding('binary'),
              filename: "startups_#{params[:type]}.xls"
  end

  def destroy
    if @startup.destroy
      flash[:notice] = { title: 'Done', text: 'Startup was deleted' }
    end
  end

  def cancel;end

  def add_pdf
    @startup_pdf = StartupPdf.new(startup_pdf_params)
    @startup_pdf.startup_id = @startup.id
    @startup_pdf.is_tmp = true
    @startup_pdf.save
  end

  def destroy_pdf
    @startup_pdf = @startup.pdf_documents.with_deleted.find_by(id: params[:pdf_id])
    @startup_pdf.destroy if @startup_pdf
  end

  private

  def set_startup
    @startup = Startup.find_by(id: params[:startup_id])
  end

  def pdf_after_save_actions
    @startup.pdf_documents.only_deleted.each { |d| d.really_destroy! }
    @startup.save_tmp_pdf_documents!
  end

  def pdf_after_cancel_actions
    if @startup
      StartupPdf.restore(@startup.pdf_documents.only_deleted.pluck(:id))
      @startup.destroy_tmp_pdf_documents!
    end
  end

  def set_download_startup_ids
    session[:download_startup_ids] =
      @startups.any? ? @startups.page(1).per(@startups.total_count).map(&:id) : []
  end

  def get_startup_tags
    @predefined_tags = @startup.tags.where(user_id: current_user.team_mate_ids).pluck(:title)
  end

  def set_gon
    gon.predefined_tags = @predefined_tags
    gon.startup_tags_path = startup_tags_path(@startup)
  end

  def find_startup
    @startup = Startup.includes(:startup_brief_summaries, :tags, :scorecards).find_by(id: params[:id]).try :decorate
    redirect_to startups_path unless @startup
  end

  def find_startup_brand
    @startup ||= Startup.find_by(id: params[:id]).decorate
    if @startup.promo_briefs.any?
      @from_brand = @startup.promo_briefs.first.promo_page.brand.decorate
    end
  end

  def startup_params
    return {} unless params[:startup]
    params.require(:startup)
          .permit(:title, :description, :location, :website, :twitter,
                  :video_url, :contact_name, :contact_email, :founders,
                  :date_founded, :elevator_pitch, :frame_of_reference,
                  :connection_source, :outreach_status, :prefilled_brief,
                  :logo, :month, :year, :skip_validation, :logo_cache, watcher_ids:[],
                  founders_attributes:[:id, :name, :avatar, :_destroy,
                                       :avatar_cache, :skip_validation])
          .merge(creator_id: current_user.id)
  end

  def startup_pdf_params
    params.require(:startup_pdf).permit(:file)
  end

  def watchlist_params
    params.require(:startup)
        .permit(:contact_name, :contact_email, :connection_source,
                :outreach_status, :title, :description,
                :location, :website, :twitter, :video_url,
                watcher_ids: [], founders_attributes:
                [:id, :name, :skip_validation])
        .merge(updater_id: current_user.id,
               skip_validation: true)
  end

  def brand_startups_params
    params.require(:brand_startup).permit(:brand_id)
  end

  def list_startups_params
    params.require(:list_startup).permit(:list_id)
  end

  def search_params
    params.require(:startup).permit(:query)
  end

  def find_favorite_list
    @favorite_list = current_user.favorite_list
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def form_summary
    @summary = @startup.form_brief_results if @startup.startup_brief_summaries
                                                      .where(startup_promo_brief_id: nil,
                                                             startup_brand_brief_id: nil)
                                                      .any?
  end

  def form_promo_results
    if @startup.startup_brief_summaries.where.not(startup_promo_brief_id: nil)
                                       .where(startup_brand_brief_id: nil)
                                       .any?

      @promo_summary = @startup.form_promo_answers(current_user.evo_team? ||
                          current_user.startup? ? nil : current_user.brand.promo_page_ids)
      @promo_questions = PromoPageQuestion.includes(:promo_page_question_answers)
                                          .where(promo_page_id: @promo_summary.keys)
                                          .order(:promo_page_id)

    end
  end

  def form_brand_results
    if @startup.startup_brief_summaries.where(startup_promo_brief_id: nil)
                                       .where.not(startup_brand_brief_id: nil)
                                       .any?

      @brand_summary = @startup.form_brand_results(current_user.evo_team? ||
                          current_user.startup? ? nil : current_user.brand_id)
      @brand_questions = BrandQuestion.includes(:brand_question_answers)
                                      .where(brand_id: @brand_summary.keys)
                                      .order(:brand_id)
    end
  end

  def pushing_startup_activity
    return false unless @brand_startup
    activity = Activity.find_by(alias: 'startup_pushed')

    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{startup_name}}', '{{brand_name}}'],
                                   replacements: [current_user.full_name, @brand_startup.startup.title, @brand.title])

    user_activity = UserActivity.create(user: current_user, activity: activity, resource_id: @brand.id,
                        evo_text: texts[:evo], brand_text: texts[:brand],
                        resource_type: UserActivity.resource_types[:brand], evo_logo: true)

    BrandMailer.startup_pushed(user_activity, @brand).deliver_now
  end

  def brief_questions
    step = Startup::STEPS.index(@startup.current_step)
    @brief_questions = StartupBriefQuestionDecorator.decorate_collection(
        StartupBriefQuestion.preload(answers: [:category_value])
            .step(step).order(:question_order))
  end

  def create_session_params
    params_startup = startup_params
    params_startup.delete('logo')
    params_startup['logo_cache'] = @startup.logo_cache
    i = 0
    params_startup['founders_attributes'].each do |index, founder|
      params_startup['founders_attributes'][index].delete('avatar')
      params_startup['founders_attributes'][index]['avatar_cache'] = @startup.founders[i].avatar_cache
      i += 1
    end
    params_startup
  end

  def resolve_layout
    case action_name
    when 'profile', 'questions', 'notes', 'tasks', 'requests', 'activity'
      'startup_profile'
    when 'index', 'watchlist'
      'dashboard'
    when 'home', 'cabinet'
      'startup'
    else
      'application'
    end
  end
end
