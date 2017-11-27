class ApplicationMailer < ActionMailer::Base
  include ::UserActivitiesHelper
  add_template_helper(UserActivitiesHelper)
  default from: 'Pipeline <info@startupsforbrands.com>'
  layout 'mailer'

  def prepare_merge_vars(users)
    emails, merge_vars = [], []
    users.each do |user|
      emails << { email: user.email }
      merge_vars << {
        rcpt: user.email,
        vars: [
          { name: 'user_name', content: user.full_name }
        ]
      }
    end
    [emails, merge_vars]
  end

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(ENV['MANDRILL_API_KEY'])
  end

  def send_notification(data)
    emails, merge_vars = prepare_merge_vars(data[:users])
    notification = data[:notification]
    message = {
      to: emails,
      subject: data[:subject],
      global_merge_vars: [
        { name: 'notification_image', content: activity_email_image(notification) },
        { name: 'notification_time', content: activity_time_at(notification.created_at) },
        { name: 'notification_body', content: data[:body] },
        { name: 'notification_author', content: notification.evo_logo? ? 'Evol8tion' : notification.user.full_name },
        { name: 'activities_url', content: activities_url }
      ],
      merge_vars: merge_vars
    }

    send_message('notification-template', [], message)
  end

  def send_message(slag, content = [], message)
    if ActionMailer::Base.default_url_options[:host] != 'localhost' || Rails.configuration.emails_on_localhost
      mandrill_client.messages.send_template(slag, content, message)
    end
  end

end
