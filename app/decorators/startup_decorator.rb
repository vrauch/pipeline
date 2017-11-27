class StartupDecorator < Draper::Decorator
  delegate_all

  DATE_FORMAT = 'Profile created on %m/%d/%Y'

  def has_complete_scorecards?
    scorecards.complete.try(:any?)
  end

  def back_referer_path
    h.session[:back_referer] ? h.session[:back_referer] : h.startups_path
  end

  def logo_url
    logo? ? h.image_tag(logo.thumb_medium, alt: 'Logo', width: 90) : initial
  end

  def member_since
    created_at.strftime(DATE_FORMAT)
  end

  def brand_member_since
    brand_startups.find_by(brand_id: h.current_user.brand_id).present? ?
        brand_startups.find_by(brand_id: h.current_user.brand_id).created_at.strftime(DATE_FORMAT) :
        member_since
  end

  def location_name
    handle_none location do
      location
    end
  end

  def founded_date
    handle_none date_founded do
      date_founded
    end
  end

  def full_description
    handle_none description do
      h.auto_link(h.simple_format(description), html: { target: '_blank', class: 'sidebar_link' })
    end
  end

  def website_url
    handle_none website do
      h.auto_link(website, html: { target: '_blank', class: link_class })
    end
  end

  def twitter_link
    return '' if twitter.blank?
    slug = twitter
    at_index = slug.index('@')
    twitter_url = at_index.nil? ? "@#{slug}" : slug[at_index..-1]

    h.link_to twitter_url, "https://twitter.com/#{twitter_url}",
              class: link_class, target: '_blank'
  end

  def video
    h.auto_link(video_url, html: { target: '_blank', class: link_class })
  end

  def lighten
    owner_id || prefilled_brief ? '' : 'tags__lighten'
  end

  def edit_path
    owner_id || prefilled_brief ? h.edit_startup_path(object) : h.edit_watchlist_startup_path(object)
  end

  def background
    logo? ? "background-image: url(#{h.asset_path logo.thumb_large.url})" : ''
  end

  def active_class?
    logo? ? 'active' : ''
  end

  def next_or_save
    if last_step?
      persisted? ? 'EDIT STARTUP' : 'ADD STARTUP'
    else
      'NEXT'
    end
  end

  def connection_source_info
    handle_none connection_source do
      connection_source
    end
  end

  def outreach_status_info
    handle_none outreach_status do
      outreach_status
    end
  end

  def button_name
    last_step? ? 'save_button' : 'next_button'
  end

  def invitable?
    prefilled_brief? && owner.nil? && h.current_user.evo_team? || owner.nil? && !prefilled_brief?
  end

  def type_of_startup(current_user)
    if current_user.evo_team?
      if startup.owner && startup.owner.invite.blank? && startup.promo_briefs.empty? ||
            startup.owner && startup.owner.invite.try(:sender).try(:evo_team?)
        { html_class: 'founder_label', value: 'Founder Evol8tion' }
      elsif startup.prefilled_brief? && startup.owner.blank?
        { html_class: 'generated_label', value: 'Evol8tion Generated' }
      elsif startup.owner.blank?
        { html_class: 'evo_label', value: 'Watchlist' }
      elsif startup.owner && startup.owner.invite.try(:sender).try(:brand_team?) || startup.owner && startup.promo_briefs.any?
        { html_class: 'founder_brand_label', value: 'Founder-Brand' }
      end
    else
      if startup.brand_startups.any?
        { html_class: 'founder_label', value: 'Evol8tion' }
      elsif startup.owner && startup.owner.invite.try(:sender).try(:brand_team?) || startup.promo_briefs.any?
        { html_class: 'founder_brand_label', value: 'Founder' }
      elsif startup.owner.blank?
        { html_class: 'evo_label', value: 'Watchlist' }
      end
    end
  end

  private

  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :span, 'none specified', class: 'some-transparency'
    end
  end

  def link_class
    owner_id || prefilled_brief ? 'sidebar_link' : 'black_link'
  end

end
