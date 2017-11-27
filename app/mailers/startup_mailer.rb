class StartupMailer < ApplicationMailer
  include Devise::Controllers::UrlHelpers
  require 'pry'

  def question_sent(notification, question)
    send_notification(notification: notification, body: notification.startup_text,
                      subject: 'Evol8tion asked question', users: [question.startup.owner])
  end

  def confirmation_instructions(startup, brand, token)
    if brand
      subject = "Welcome to #{brand.title}'s Pipeline!"
      logo_url = brand.email_template.email_logo? ? brand.email_template.email_logo.url : brand.logo.url
      brand_vars_vars = [
        { name: 'brand_name', content: brand.title },
        { name: 'brand_image', content: generate_image_url(logo_url) },
        { name: 'email_text', content: brand.email_template.copy_for_email },
        { name: 'email_color', content: brand.email_template.email_color }
      ]
      template = 'startup-registration-via-brand'
    else
      subject = 'Welcome to Pipeline!'
      brand_vars_vars = []
      template = 'startup-registration-via-evol8tion'
    end

    global_merge_vars = [
      { name: 'user_name', content: startup.owner.f_name },
      { name: 'confirmation_link', content: confirmation_url(startup.owner, confirmation_token: token) },
    ]

    message = {
      to: [ { email: startup.owner.email } ],
      subject: subject,
      global_merge_vars: global_merge_vars + brand_vars_vars
    }

    send_message(template, [], message)
  end

  def announcement_received(startups, announcement)
    startup_emails, merge_vars = [], []
    startups.each do |startup|
      next unless startup.receive_emails
      startup_emails << { email: startup.owner.email }
      merge_vars << {
        rcpt: startup.owner.email,
        vars: [
          { name: 'post_url', content: startup_announcements_url(startup) }
        ]
      }
    end
    message = {
      to: startup_emails,
      subject: 'M+MV post was sent',
      global_merge_vars: [
        { name: 'post_title', content: announcement.title },
        { name: 'post_desc', content: strip_announcement_content(announcement.content) },
        { name: 'post_image_url', content: announcement.cover.present? ? announcement_cover_external_url(announcement) : nil }
      ],
      merge_vars: merge_vars
    }

    send_message('new-m-mv', [], message)
  end
end
