class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session

  layout :set_layout
  before_action :clear_search_session, except: :profile
  # check_authorization unless: :do_not_check_authorization?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { flash.now[:error] = 'Please, sign up to continue' }
      format.html { redirect_to root_path, alert: 'Please, sign up to continue' }
    end
  end

  private

  def set_layout
    user_signed_in? ? 'dashboard' : 'application'
  end

  def check_invite_token
    @invite = Invite.find_by(token: params[:invite_token]) unless params[:invite_token].nil?
  end

  def active_user
    return unless @invite
    @user = User.preload(:insight_summaries,
                          insight_summaries: [:insight_group, :diagnostic_type])
                .find_by(invite_token_id: @invite.id)
    redirect_to new_user_session_path if @user && @user.active?
  end

  def do_not_check_authorization?
    respond_to?(:devise_controller?) or
    respond_to?(:welcome_controller?)
  end

  def clear_search_session
    if params[:back_search] && session[:search_back]
      gon.push({search_back: session[:search_back]})
    end
    session[:search_back] = nil
  end
end
