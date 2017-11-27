class BrandMailer < ApplicationMailer

  def new_startup(notification, brand)
    send_notification(notification: notification, body: notification.brand_text,
                      subject: 'New Startup Account', users: brand.users.brand_super_users)
  end

  def startup_filled_in_profile(notification, brand)
    send_notification(notification: notification, body: notification.brand_text,
                      subject: 'Startup Completed Profile', users: brand.users.brand_super_users)
  end

  def startup_pushed(notification, brand)
    send_notification(notification: notification, body: notification.brand_text,
                      subject: 'Startup was pushed', users: brand.users.brand_super_users)
  end

  def scorecard_pushed(notification, brand)
    send_notification(notification: notification, body: notification.brand_text,
                      subject: 'Scorecard was pushed', users: brand.users.brand_super_users)
  end

  def request_answer(notification, answer)
    brand_super_users = answer.request.brand.users.brand_super_users
    author = answer.request.author
    all_users = brand_super_users << author

    send_notification(notification: notification, body: notification.brand_text,
                      subject: 'Evol8tion answered on request', users: all_users)
  end

  def promo_page_status(promo_page)
    brand_users = promo_page.brand.users.brand_super_users << promo_page.creator
    brand_users.uniq!(&:id)

    if promo_page.published?
      subject = 'Landing page was approved'
      text = 'Landing page was approved and published'
    else
      subject = 'Landing page was rejected'
      text = 'Landing page was rejected. To see details go to Settings > Landing Page'
    end

    emails, merge_vars = prepare_merge_vars(brand_users)

    message = {
        to: emails,
        subject: subject,
        global_merge_vars: [
          { name: 'notification_image', content: generate_image_url(ActionController::Base.helpers.image_url('layout/evol8tion.png')) },
          { name: 'notification_time', content: activity_time_at(promo_page.updated_at) },
          { name: 'notification_body', content: text },
          { name: 'notification_author', content: 'Evol8tion' },
          { name: 'activities_url', content: activities_url }
        ],
        merge_vars: merge_vars
    }

    send_message('notification-template', [], message)

  end

  def announcement_received(brands, announcement)

    brand_emails = brands.joins(:users).pluck(:email).map { |email| { email: email } }
    message = {
      to: brand_emails,
      subject: 'M+MV post was sent',
      global_merge_vars: [
        { name: 'post_title', content: announcement.title },
        { name: 'post_desc', content: strip_announcement_content(announcement.content) },
        { name: 'post_image_url', content: announcement.cover.present? ? announcement_cover_external_url(announcement) : nil },
        { name: 'post_url', content: url_for(announcement) }
      ]
    }

    send_message('new-m-mv', [], message)
  end
end
