module RequestsHelper
  def pointed_image(request)
    if current_user.evo_team?
      request.answer.present? ? '' : 'pointed' 
    else 
      request.answer.present? && request.answer.new? ? 'pointed' : ''
    end 
  end

  def request_image(request)
    if request.startup? && request.startup_logo.present?
      link_to profile_startup_path(request.startup), class:'activity_link' do
        image_tag(request.startup_logo.thumb_medium)
      end
    elsif request.startup? && request.startup_logo.blank?
      request.startup.initial.upcase
    else
      image_tag(asset_path("#{request.request_type}.svg"))
    end
  end

  def request_date(request)
    request.created_at.strftime("%B #{request.created_at.day.ordinalize}, %Y %I:%M %p")
  end
end
