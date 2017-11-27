class TagsController < ApplicationController
  include ApplicationHelper
  # load_and_authorize_resource

  before_action :find_tag, only: :show
  after_action :set_download_startup_ids, only: [:show]

  def index
    user_ids = current_user.evo_team? ? User.evo_users.pluck(:id)
                                      : current_user.brand_user_ids
    @tags = Tag.where(user_id: user_ids)
    @search = params[:search]
    @tags = @tags.search_by_title(@search) if @search
    @tags = @tags.page(params[:page])
  end

  def new
    @startup = Startup.find_by(id: params[:startup_id])
    @tag = Tag.new
  end

  # TODO: if add pagination for startups, you need uncomment line in set_download_startup_ids method
  def show
    user_ids = current_user.evo_team? ? User.evo_users.pluck(:id)
                                      : current_user.brand_user_ids

    @startups = @tag.startups.where(tags: { user_id: user_ids })
                             .includes(:tags)
                             .preload(:invite, owner: [{ invite: [:sender] }])
                             .order("startups.#{sort_column}" + " " + sort_direction)

    @favorite_list = List.includes(:startups).favorite_list(current_user)
    @startup_tags = StartupTag.startup_tags(@startups.pluck(:id), current_user.team_mate_ids)
    @back_link = tags_url(search: params[:tags_search], page: params[:tags_page])
  end

  private

  def find_tag
    @tag = Tag.find_by(id: params[:id])
  end

  def set_download_startup_ids
    session[:download_startup_ids] =
      @startups.any? ?  @startups.map(&:id) : []
      # @startups.any? ?  @startups.per(@startups.total_count).page(1).map(&:id) : []
  end
end
