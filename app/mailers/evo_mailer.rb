class EvoMailer < ApplicationMailer

  def notification(notification, subject, data = {})
    if data[:without_current]
      users = User.evo_super_users.where.not(email: notification.user.email)
    elsif data[:with_current]
      users = User.evo_super_users << data[:user]
      users.uniq!(&:id)
    elsif data[:only_current]
      users = [data[:user]]
    else
      users = User.evo_super_users
    end

    send_notification(notification: notification, body: notification.evo_text,
                      subject: subject, users: users)
  end

end