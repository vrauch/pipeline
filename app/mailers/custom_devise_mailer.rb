class CustomDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(ENV['MANDRILL_API_KEY'])
  end

  def reset_password_instructions(record, token, opts = {})
    message = {
      to: [ { email: record.email } ],
      subject: 'Reset Your Pipeline Password',
      global_merge_vars: [
        { name: 'first_name', content: record.f_name },
        { name: 'reset_password_link', content: edit_password_url(record, reset_password_token: token) },
      ]
    }

    mandrill_client.messages.send_template('reset-your-password', [], message)
  end

  def confirmation_instructions(record, token, opts = {})

  end

end
