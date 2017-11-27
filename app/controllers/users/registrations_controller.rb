class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
# before_filter :configure_permitted_parameters
  before_action :check_invite_token, only: [:new, :create]
  before_action :user_exists, only: [:new, :create]
  before_action :promo_token, only: [:new, :create]
  after_action :save_activity, only: [:create]
#   before_action :active_user, only: [:new]

  layout 'devise'

  # GET /resource/sign_up
  def new
    if @invite
      if @invite.user
        @user = @invite.user
      else
        @user = case
          when @invite.evo_team?
            UserEvo.new
          when @invite.brand_team?
            UserBrand.new
          else
            UserStartup.new
        end
      end
    else
      @user = UserStartup.new
      @user.build_startup
    end
  end

  # POST /resource
  def create
    if @invite
      @user = case
        when @invite.evo_team?
          UserEvo.new(evo_sign_up_params)
        when @invite.brand_team?
          UserBrand.new(brand_sign_up_params)
        else
          UserStartup.new(startup_sign_up_params)
      end
    else
      @user = UserStartup.new(startup_sign_up_params)
      @user.build_startup(startup_params)
    end


    if @user.save
      if @user.evo_team?
        sign_in(:user, @user)
      elsif @user.brand_team?
        @invite.brand.brand_users.create(user: @user)

        # Temp decision
        @brief = @user.brand.brand_brief
        if @brief
          @user.update_attribute(:active, 1)
          sign_in(:user, @user)
        end

      elsif  @user.startup?
        if @invite
          sign_in(:user, @user)
          @invite.startup.update_attribute(:owner_id, @user.id)
        elsif @promo_page
          @user.startup.promo_briefs.create(promo_page_id: @promo_page.id)
        end
      end
    end
  end

  # GET /resource/edit
  # def edit
    # super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
  def save_activity
    return false if @user.invalid?
    if @user.startup?
      save_startup_activity
    elsif @user.brand_team?
      save_brand_activity
    else
      save_evo_activity
    end
  end

  def save_startup_activity
    if @promo_page || @invite && @invite.sender.brand_team?
      if @promo_page
        brand_title = @promo_page.brand.title
        brand = @promo_page.brand
      else
        brand_title = @invite.sender.brand.title
        brand = @invite.sender.brand
      end
      activity = Activity.find_by(alias: 'startup_created_brand_account')
      send_brand_notification = true
    else
      brand_title = ''
      activity = Activity.find_by(alias: 'startup_created_evo_account')
    end
    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{startup_name}}', '{{brand_name}}'],
                                   replacements: [@user.startup.title, brand_title])

    user_activity = UserActivity.create(user: @user, activity: activity,
                        resource_id: @user.startup.id,
                        resource_type: UserActivity.resource_types[:startup],
                        evo_text: texts[:evo], brand_text: texts[:brand])

    StartupMailer.confirmation_instructions(@user.startup, brand, @user.confirmation_token).deliver_now
    # EvoMailer.notification(user_activity, 'New Startup Account').deliver_now
    # BrandMailer.new_startup(user_activity, brand).deliver_now if send_brand_notification
  end

  def save_brand_activity
    activity = Activity.find_by(alias: 'brand_user_created_profile')
    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{brand_name}}'],
                                   replacements: [@user.full_name, @user.brand.title])

    user_activity = UserActivity.create(user: @user, activity: activity,
                                        resource_id: @user.brand.id,
                                        resource_type: UserActivity.resource_types[:brand],
                                        evo_text: texts[:evo], brand_text: texts[:brand])

    EvoMailer.notification(user_activity, 'New brand user').deliver_now
  end

  def save_evo_activity
    activity = Activity.find_by(alias: 'evo_user_created_profile')
    texts = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}'],
                                   replacements: [@user.full_name])

    user_activity = UserActivity.create(user: @user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])

    EvoMailer.notification(user_activity, 'New evo user', without_current: true).deliver_now
  end

  def evo_sign_up_params
    params.require(:user_evo)
          .permit(:photo, :photo_cache, :full_name, :about, :password,
                  :password_confirmation)
          .merge(invite_params)
  end

  def brand_sign_up_params
    params.require(:user_brand)
          .permit(:photo, :photo_cache, :full_name, :about, :job_title,
                  :password, :password_confirmation)
          .merge(invite_params)
  end

  def startup_sign_up_params
    sign_up_params = params.require(:user_startup)
          .permit(:full_name, :email, :password, :password_confirmation, :promo_token)

    if @invite
      sign_up_params.merge!(invite_params)
    else
      sign_up_params.merge!(role: :startup)
    end

    sign_up_params
  end

  def invite_params
    { email: @invite.email, role: @invite.role, invite_token_id: @invite.id }
  end

  def startup_params
    params.require(:startup).permit(:title).merge(skip_validation: true)
  end

  def user_exists
    redirect_to new_user_session_path if @invite.try(:user) && @invite.user.active?
  end

  def promo_token
    @promo_page = PromoPage.find_by(token: params[:promo_token]) if params[:promo_token]
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) do |user_params|
  #     user_params.permit(:full_name, :job_title, :about, :email, :password, :password_confirmation)
  #   end
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
