class ListsController < ApplicationController
  include ApplicationHelper
  # load_and_authorize_resource
  before_action :find_list, only: [:edit, :show, :update, :destroy,
                                   :remove_from, :delete_alert]

  before_action :get_tags_count, only: [:create, :show, :remove_from,
                                        :add_to_favorites, :remove_from_favorites]
  after_action :creating_list_activity, only: [:create]
  after_action :updating_list_activity, only: [:update]
  after_action :set_download_startup_ids, only: [:show]

  def index
    @favorite_list = current_user.favorite_list
    @lists = List.team_lists(current_user).includes(:author).sort
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(create_list_params)
    flash.now[:notice] = { title: 'Done', text: 'List was successfully created!' } if @list.save
  end

  def show
    @favorite_list = List.favorite_list(current_user)
    @startups = @list.startups.includes(:invite, :brand_startups, owner: [{ invite: [:sender] }])
                              .page(params[:page])
                              .order("startups.#{sort_column}" + " " + sort_direction)
    get_startup_tags
    render layout: 'layouts/startup/list'
  end

  def update
    flash.now[:notice] = { title: 'Done', text: 'List was successfully updated' } if @list.update(update_list_params)
  end

  def destroy
    if @list.favorite?
      flash.now[:notice] = { title: 'Error', text: 'Cannot destroy favorite list' }
    else
      flash.now[:notice] = { title: 'Done', text: 'List was successfully destroyed' } if @list.destroy
    end
  end

  def remove_from
    @startup = Startup.find_by(id: params[:startup_id])
    if @list.startups.destroy(@startup)
      flash.now[:notice] = { title: 'Done', text: 'Startup has been removed from list' }
    end
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  def add_to_favorites
    @startup = Startup.find_by(id: params[:startup_id])
    @favorite_list = List.includes(:startups).favorite_list(current_user)
    @favorite_list.startups << @startup
    flash.now[:notice] = { title: 'Done', text: 'Startup has been added to favorite' }
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  def remove_from_favorites
    @startup = Startup.find_by(id: params[:startup_id])
    @favorite_list = List.includes(:startups).favorite_list(current_user)
    if @favorite_list.startups.destroy(@startup)
      flash.now[:notice] = { title: 'Done', text: 'Startup has been removed from favorite list' }
    end
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  def search
    @startup = Startup.find_by(id: params[:startup_id])
    @lists = List.team_lists(current_user).where('name LIKE ?', "%#{search_params[:query]}%")
    @startup_lists = @startup.lists.pluck(:id)
  end

  def sort
    params[:order].each do |key, list|
      List.find(list[:id]).update_attribute(:priority, list[:position])
    end
    respond_to :js
  end

  def reset_sorting
    List.team_lists(current_user).update_all(priority: nil)
    redirect_to lists_url
  end

  private

  def set_download_startup_ids
    session[:download_startup_ids] =
      @startups.any? ?  @startups.per(@startups.total_count).page(1).map(&:id) : []
  end

  def create_list_params
    params.require(:list).permit(:name, :author_id)
                         .merge(author_id: current_user.id)

  end

  def update_list_params
    params.require(:list).permit(:name)
  end

  def search_params
    params.require(:list).permit(:query)
  end

  def find_list
    @list = List.includes(:startups, startups: [:owner]).find_by(id: params[:id])
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

  def creating_list_activity
    return false if @list.invalid?

    activity_alias = current_user.evo_team? ? 'list_created_by_evo' : 'list_created_by_brand'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{list_name}}'],
                                   replacements: [current_user.full_name, @list.name])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def updating_list_activity
    return false if @list.invalid?

    if @list.previous_changes.any?
      activity_alias = current_user.evo_team? ? 'list_edited_by_evo' : 'list_edited_by_brand'
      activity = Activity.find_by(alias: activity_alias)

      texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                                 evo: activity[:evo_pattern] },
                                     replaces: ['{{user_name}}', '{{list_name}}'],
                                     replacements: [current_user.full_name, @list.name])

      UserActivity.create(user: current_user, activity: activity,
                          evo_text: texts[:evo], brand_text: texts[:brand])
    end
  end
end
