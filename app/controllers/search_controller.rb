class SearchController < ApplicationController
  include SearchHelper
  include ApplicationHelper
  before_action :user_search, only: [:edit, :update, :show, :destroy, :edit_name, :update_name]
  before_action :categories, only: [:new, :edit, :create, :update, :advanced]
  before_action :advanced_search, only: [:adv]
  before_action :check_session, only: [:adv_filter, :create, :update]
  before_action :favorite_list, only: [:quick, :adv, :show]
  before_action :clear_session, only: [:show]
  before_action :get_tags_count, only: [:advanced_search, :quick, :adv, :show,
                                        :adv_filter]
  after_action :saving_search_activity, only: [:create]
  after_action :updating_search_activity, only: [:update, :update_name]
  after_action :save_url, only: [:quick, :adv, :adv_filter]
  after_action :set_download_startup_ids, only: [:quick, :adv, :by_categories, :show, :check_session, :adv_filter]

  load_and_authorize_resource

  def quick
    if params[:search].blank?
      @startups = []
    else
      startups = Startup.all_startups(current_user)
      tag_titles = params[:search][0] == '#' ? params[:search][1..-1] : ''

      @startups = Startup.search params[:search],
        page: params[:page], per_page: 25,
        sql: { include: [:lists, :owner, :invite, :promo_briefs] },
        with: { id: startups.any? ? startups.pluck(:id) : 0 },
        conditions: { tag_titles: tag_titles },
        order: sort_column + " " + sort_direction
      get_startup_tags
    end
    session[:back_search_result] = params
  end

  def by_categories
    @back_link = params[:back_link].present? ? params[:back_link] : dashboard_url
    if params[:search].present?
      category_values = CategoryValue
        .where(id: params[:search][:category_value_ids]).select(:id, :content, :icon_name)
    else
      category_values = CategoryValue.all.select(:id, :content, :icon_name)
    end
    @search_params = {
      search: { category_value_ids: category_values.collect(&:id),
                startup_type: :all_startups }
    }
    @custom_search_query = category_values.collect(&:content).join(', ')
    @custom_search_icon = 'icon__' + category_values.last.icon_name
    @back_title = 'X Close'
    advanced_search

    render :by_categories, layout: 'dashboard'
  end

  def adv
    session[:new_advanced_search] = search_params
    if params[:search][:id]
      session[:new_advanced_search][:id] = params[:id] = params[:search][:id]
      user_search
    else
      new_search
    end
  end

  def adv_filter
  end

  def advanced
    if params[:back_to_form].present? && params[:search].present?
      @search = Search.new search_form_params
    elsif params[:back_search].blank? || session[:back_search_result].blank?
      new_search
    else
      backsearch = session[:back_search_result][:search]
      backsearch.delete(:name)
      backsearch.delete(:startups)
      @search = Search.new(backsearch.permit!)
    end
  end

  def saved
    @searches = Search.saved_search(current_user)
  end

  def show
    params[:search] = @search.attributes
    params[:search][:category_value_ids] = @search.category_values.ids
    advanced_search
    render layout: 'layouts/startup/search'
  end

  def new
    new_search
  end

  def edit
  end

  def create
    @search = Search.new(search_params)
    if @search.save
      clear_session
      flash.now[:notice] = { title: 'Done', text: 'Advanced Search was successfully saved.' }
    else
      flash.now[:error] = { title: 'Done', text: 'Advanced Search saved error.' }
    end
  end

  def update
    @search.update_attributes(search_params)
    if @search.errors.empty?
      clear_session
      flash.now[:notice] = { title: 'Done', text: 'Advanced search was successfully updated.' }
    else
      flash.now[:error] = { title: 'Done', text: 'Advanced search update error.' }
    end
  end

  def destroy
    if @search.nil?
      flash.now[:error] = { title: 'Done', text: 'Advanced search couldn\'t be destroyed' }
    else
      @search.destroy
      @searches_count = Search.saved_search(current_user).count
      flash.now[:notice] = { title: 'Done', text: 'Advanced search successfully deleted.' }
    end
  end

  def edit_name
  end

  def update_name
    @search.update_attributes(save_name)
    if @search.errors.empty?
      flash.now[:notice] = { title: 'Done', text: 'Advanced search name was successfully updated.' }
    else
      flash.now[:error] = { title: 'Done', text: 'Advanced search name update error.' }
    end
  end

  private

  def search_params
    params.require(:search).permit(
      :name,
      :location,
      :search,
      :added_from,
      :added_to,
      :startup_type,
      category_value_ids: []
    ).merge(user_id: current_user.id, number_startups: @startups.count)
  end

  def set_download_startup_ids
    session[:download_startup_ids] =
      @startups.any? ?  @startups.per(@startups.total_count).page(1).map(&:id) : []
  end

  def search_form_params
    params.require(:search).permit(
      :name,
      :location,
      :search,
      :added_from,
      :added_to,
      :startup_type,
      category_value_ids: []
    )
  end

  def user_search
    @search = Search.user_search(params[:id], current_user)
  end

  def categories
    @categories = Category.all.includes(:category_values)
    if current_user.evo_team?
      @submissions = Search::EVO_SUBMISSIONS
    else
      @submissions = Search::BRAND_SUBMISSIONS
    end
  end

  def advanced_search
    search = params[:search]
    startups = Startup.send(search[:startup_type], current_user)
    params[:search][:startups] = startups.pluck(:id) if startups.any?
    if params[:search][:search].blank? && advanced_conditions.blank? &&
       advanced_with_all.blank? && advanced_with.blank? && startups.blank?
      @startups = []
    else
      tag_titles = search[:search] && search[:search][0] == '#' ? search[:search][1..-1] : ''
      @startups = Startup.search search[:search],
        page: 1, per_page: startups.count,
        sql: { include: [:lists, :owner, :invite, :promo_briefs] },
        conditions: advanced_conditions,
        with_all: {:answer_id => advanced_with_all },
        with: advanced_with,
        conditions: { tag_titles: tag_titles },
        order: sort_column + " " + sort_direction
      @startups = Kaminari.paginate_array(@startups).page(params[:page]).per(25)
      get_startup_tags
    end
    params[:search][:startups] = nil
    session[:back_search_result] = params
  end

  def check_session
    if session[:new_advanced_search]
      session[:new_advanced_search][:name] = params[:search][:name] unless params[:search].nil?
      params[:search] = session[:new_advanced_search]
    end
    advanced_search
  end

  def favorite_list
    @favorite_list = List.includes(:startups).favorite_list(current_user)
  end

  def save_name
    params.require(:search).permit(:name)
  end

  def clear_session
    session[:new_advanced_search] = nil
  end

  def new_search
    @search = Search.new
  end

  def get_tags_count
    @tag_counts = StartupTag.where(user_id: current_user.evo_team? ?
                                            User.evo_users.pluck(:id) :
                                            current_user.brand_user_ids)
                            .group(:startup_id)
                            .count(:id)
  end

  def get_startup_tags
    startup_ids = []
    @startups.each { |s| startup_ids << s.id }
    @startup_tags = StartupTag.startup_tags(startup_ids, current_user.team_mate_ids)
  end

  def saving_search_activity
    return false if @search.invalid?

    activity_alias = current_user.evo_team? ? 'saved_search_created_by_evo' : 'saved_search_created_by_brand'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{search_name}}'],
                                   replacements: [current_user.full_name, @search.name])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def updating_search_activity
    return false if @search.invalid?

    if @search.previous_changes.any?
      activity_alias = current_user.evo_team? ? 'saved_search_edited_by_evo' : 'saved_search_edited_by_brand'
      activity = Activity.find_by(alias: activity_alias)

      texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                                 evo: activity[:evo_pattern] },
                                     replaces: ['{{user_name}}', '{{search_name}}'],
                                     replacements: [current_user.full_name, @search.name])

      UserActivity.create(user: current_user, activity: activity,
                          evo_text: texts[:evo], brand_text: texts[:brand])
    end
  end

  def save_url
    session[:search_back] = {
      action: action_name,
      search: session[:back_search_result]
    }
  end
end
