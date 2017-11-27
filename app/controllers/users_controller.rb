class UsersController < ApplicationController
  include UsersHelper

  before_action :set_user, only: [:activity, :diagnostic, :reset_password, :destroy]

  def index
    if current_user.evo_team?
      roles = [User.roles[:evo], User.roles[:evo_super]]
      @users = User.where(role: roles).order(created_at: :desc)
      @users += Invite.where(role: roles).where.not(email: @users.pluck(:email)).order(created_at: :desc)
    else
      roles = [User.roles[:brand], User.roles[:brand_super]]
      @brand = current_user.brand
      @users = @brand.users.preload(:summary_diagnostic_type).order(created_at: :desc)
      @users += Invite.where(role: roles).where.not(email: @users.pluck(:email))
                      .where(resource_id: @brand.id).order(created_at: :desc)
    end
    @users.sort_by!(&:created_at).reverse!
  end

  def edit
    if current_user.evo_team?
      @user = UserEvo.find_by(id: params[:id])
    else
      @user = UserBrand.find_by(id: params[:id])
    end
  end

  def update
    if current_user.evo_team?
      @user = UserEvo.find_by(id: params[:id])
    else
      @user = UserBrand.find_by(id: params[:id])
    end
    @user.update_attributes(user_params)
    flash.now[:notice] = { title: 'Done', text: 'Changes were saved successfully' }
  end

  def reset_password
    @user.send_reset_password_instructions

    flash.now[:notice] = { title: 'Password was successfully reset',
                           text: 'Instructions were sent on the user email'}
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'User successfully deleted'
    end
  end

  def activity
    @user_activities = current_user.evo_team? ? evo_activities : brand_activities

    render layout: 'user/index'
  end

  def diagnostic
    @diagnostic_types = DiagnosticType.all
    @user = User.preload(insight_summaries: [:insight_group, :diagnostic_type])
                .find_by(id: params[:id])
    @act = @user.insight_summaries.insight_alias('act')
    redirect_to users_path unless @user
    render layout: 'user/index'
  end

  private

  def user_params
    require_param = current_user.evo_team? ? :user_evo : :user_brand
    params.require(require_param).permit(:photo, :photo_cache, :full_name,
                                         :email, :about, :role, :active,
                                         :date_of_birth)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to dashboard_path unless @user
  end

end
