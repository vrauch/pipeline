module UserActivitiesHelper
  require 'pry'

  def activity_time_at(time_at)
    time_at.strftime("%B #{time_at.day.ordinalize}, %Y %I:%M %p")
  end

  def dashboard_activity_image(activity)
    case
    when activity.user.startup?
      activity.user.startup_logo.thumb_medium.url
    when activity.brand? && !activity.evo_logo && current_user.evo_team?
      activity.brand_logo.present? ? activity.brand_logo.thumb_medium.url : 'user_mask.png'
    when activity.brand? && activity.evo_logo && current_user.brand_team?
      ActionController::Base.helpers.image_url('layout/evol8tion.png')
    when activity.startup?
      activity.startup_logo.thumb_medium.url
    else
      activity.user_photo.present? ? activity.user_photo.thumb_medium.url : 'user_mask.png'
    end
  end

  def activity_image(activity)
    case
    when activity.user.startup?
      link_to profile_startup_path(activity.user.startup), class:'activity_link' do
        image_tag(activity.user.startup_logo.thumb_medium.url, width: 82)
      end
    when activity.brand? && !activity.evo_logo && current_user.evo_team?
      link_to brand_path(activity.brand), class:'activity_link' do
        image_tag(activity.brand_logo.present? ? activity.brand_logo.thumb_medium.url : 'user_mask.png', width: 82)
      end
    when activity.brand? && activity.evo_logo && current_user.brand_team?
      image_tag(ActionController::Base.helpers.image_url('layout/evol8tion.png'), width: 82)
    else
      image_tag(activity.user_photo.present? ? activity.user_photo.thumb_medium.url : 'user_mask.png', width: 82)
    end
  end

  def activity_email_image(activity)
    if activity.evo_logo?
      generate_image_url(ActionController::Base.helpers.image_url('layout/evol8tion.png'))
    elsif activity.startup?
      generate_image_url(activity.startup_logo.thumb_medium.url)
    elsif activity.brand?
      generate_image_url(activity.brand_logo.thumb_medium.url)
    else
      generate_image_url(activity.user_photo.thumb_medium.url)
    end
  end

  def generate_image_url(image)
    image_url = image ? image : ActionController::Base.helpers.image_url('layout/user_mask.png')
    ActionMailer::Base.default_url_options[:protocol] + '://' + ActionMailer::Base.default_url_options[:host] + image_url
  end

  def strip_announcement_content(content)
    sanitized_content = ActionView::Base.full_sanitizer.sanitize(content)
    ActionController::Base.helpers.truncate(sanitized_content, length: 225)
  end

  def announcement_cover_external_url(announcement)
    image_url = File.join("uploads", "announcement", "cover", announcement.id.to_s, announcement.cover.filename.to_s)
    ActionMailer::Base.default_url_options[:protocol] + '://' + ActionMailer::Base.default_url_options[:host] + '/' + image_url
  end

  def activity_author(activity)
    case
    when activity.brand? && activity.evo_logo && current_user.brand_team?
      'Evol8tion'
    when activity.brand? && current_user.evo_team? && !activity.user.evo_team?
      activity.user_full_name + ', ' + activity.brand.title
    when activity.startup?
      activity.startup_title
    else
      activity.user_full_name
    end
  end

  def activity_text(activity)
    current_user.evo_team? ? activity.evo_text.html_safe : activity.brand_text.html_safe
  end
end
