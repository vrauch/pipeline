class Users::SessionsController < Devise::SessionsController
  # before_filter :configure_sign_in_params, only: [:create]
  before_action :promo_token, only: [:new, :create]
  before_action :brand, only: [:new, :create]

  layout 'devise'

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password]) && !(user.invite_token_id.nil? || user.active?)
      invite = Invite.find_by(id: user.invite_token_id)
      redirect_to new_user_registration_path(invite_token: invite.token)
    else
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def brand
    @brand = Brand.find_by(alias: params[:alias]) if params[:alias]
  end

  def promo_token
    @promo_page = PromoPage.find_by(token: params[:promo_token]) if params[:promo_token]
  end

  def after_sign_in_path_for(resource)
    flash.clear
    if resource.startup?
      if resource.active?
        promo_page = PromoPage.published.find_by(token: params[:promo_token]) if params[:promo_token]
        if promo_page
          resource.startup.promo_briefs.create(promo_page_id: promo_page.id)
          new_startup_promo_brief_path(promo_alias: promo_page.alias)
        else
          home_startup_path(resource.startup)
        end
      else
        edit_startup_path(resource.startup)
      end
    else

      activity = Activity.find_by(alias: resource.brand_team? ? 'brand_login' : 'evo_login')

      texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                                 evo: activity[:evo_pattern] },
                                     replaces: ['{{user_name}}'],
                                     replacements: [current_user.full_name])

      UserActivity.create(user: current_user, activity: activity,
                          evo_text: texts[:evo], brand_text: texts[:brand])

      dashboard_path
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :promo_token
  end
end
