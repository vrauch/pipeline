module AnnouncementsHelper
  def announcement_users_text(announcement)
    case
    when announcement.all_u?
      'All Users'
    when announcement.brand_u?
      'All Brands'
    when announcement.startup_u?
      'All Startups'
    end
  end
end
