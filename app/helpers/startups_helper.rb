module StartupsHelper
  def download(title, type)
    link_to title, download_startups_path(type: type), method: :post
    #button_to title, download_startups_path(type: type, startups: startups_ids)
  end

  def sort_column_for_brand
    Startup.column_names.include?(params[:sort]) ?
        params[:sort] : 'IF(brand_startups.`created_at`, brand_startups.created_at, startups.created_at)'
  end

  def startup_creation_date(startup)
    if current_user.brand_team? && startup.pushed_to_brands.include?(current_user.brand)
      startup.brand_startups.find_by(brand_id: current_user.brand_id).created_at.strftime('Profile created on %m/%d/%Y, %I:%M %p')
    else
      startup.created_at.strftime('Profile created on %m/%d/%Y, %I:%M %p')
    end
  end

  def startup_last_update_date(startup)
    if startup.updater.present?
      startup.updated_at.strftime("Last edited on %m/%d/%Y, %I:%M %p by #{startup.updater.full_name}")
    end
  end

  def brief_params
    session[:brief_params] || {}
  end
end
