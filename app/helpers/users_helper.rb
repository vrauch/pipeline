module UsersHelper

  def user_style
    if current_user.evo_team? && params[:controller] == 'brand_users' || current_user.brand_team? &&  params[:controller] == 'users'
      params[:action] == 'diagnostic' ? 'content_pt content_white' : 'content_pt'
    else
      'no_top_menu'
    end
  end

  def activity_link(user)
    if user.instance_of?(Invite)
      'javascript:;'
    else
      params[:controller] == 'brand_users' ? activity_brand_user_path(@brand, user) : activity_user_path(user)
    end
  end

  def activity_class(user)
    user.brand_team? ? 'card_item xs_size brand_users' : 'card_item md_size user_card'
  end

  def sign_in_page?
    params[:controller] == 'users/sessions' && params[:action] = 'new'
  end

  def evo_activities
    UserActivity.where(user_id: @user.id).where.not(evo_text: nil).order(created_at: :desc)
  end

  def brand_activities
    UserActivity.brand_user_activities(@user.id).where.not(brand_text: nil).order(created_at: :desc)
  end

end
