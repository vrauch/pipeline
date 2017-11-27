class StartupAnnouncementsController < ApplicationController
  layout 'startup'

  before_action :startup
  load_and_authorize_resource :announcement, through: :startup

  def index
    @announcements = Announcement.user_announcement(current_user).page(params[:page])
  end

  def show
    @announcement = Announcement.get_announcement(current_user, params[:id])
  end

  private

  def startup
    @startup = Startup.find_by(id: params[:startup_id])
  end
end
