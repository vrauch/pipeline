class BrandUsersController < ApplicationController
  # authorize_resource class: false
  include UsersHelper
  layout :set_layout

  before_action :set_brand
  before_action :set_user, only: [:diagnostic, :activity]
  before_action :set_act, only: [:diagnostic, :activity]

  def index
    roles = [User.roles[:brand], User.roles[:brand_super]]
    @users = @brand.users.order(created_at: :desc)
    @users += Invite.where(role: roles).where(resource_id: @brand.id)
                    .where.not(email: @users.pluck(:email))
                    .order(created_at: :desc)
    @users.sort_by!(&:created_at).reverse!
  end

  def diagnostic
    @diagnostic_types = DiagnosticType.all
  end

  def activity
    @user_activities = current_user.evo_team? ? evo_activities : brand_activities
  end

  private

  def set_layout
    if action_name == 'index'
      'brand/index'
    else
      'user/index'
    end

  end

  def set_brand
    @brand = Brand.find_by(id: params[:brand_id])
  end

  def set_user
    @user = User.preload(insight_summaries: [:insight_group, :diagnostic_type])
                .find_by(id: params[:id])
    redirect_to brand_users_path(@brand) unless @user
  end

  def set_act
    @act = @user.insight_summaries.insight_alias('act')
  end
end
