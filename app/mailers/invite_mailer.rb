class InviteMailer < ApplicationMailer

  def invite_brand(invite)
    template = invite.user_name ? 'brand-super-user-invite' : 'brand-user-invite'
    message = {
      to: [ { email: invite.email } ],
      subject: "Invitation to Join #{invite.brand.title}'s Pipeline",
      global_merge_vars: [
        { name: 'user_name', content: invite.user_name },
        { name: 'brand_name', content: invite.brand.title },
        { name: 'brand_logo', content: generate_image_url(invite.brand.logo.url) },
        { name: 'registration_url', content: new_user_registration_url(invite_token: invite.token) },
      ]
    }
    send_message(template, [], message)
  end

  def invite_evo(invite)
    message = {
      to: [ { email: invite.email } ],
      subject: 'Invitation to Join Pipeline',
      global_merge_vars: [
        { name: 'registration_url', content: new_user_registration_url(invite_token: invite.token) },
      ]
    }
    send_message('evo-user-invite', [], message)
  end

  def invite_startup(invite)
    if invite.sender.brand_team?
      title =  invite.sender.brand.title
      template = 'invite-startup-via-brand'
      brand_vars =  [{ name: 'brand_name', content: invite.sender.brand.title },
                     { name: 'brand_logo', content: generate_image_url(invite.sender.brand.logo.url) }]
    else
      title =  'Evol8tion'
      brand_vars = []
      template = 'invite-startup-via-evol8tion'
    end
    message = {
        to: [ { email: invite.email } ],
        subject: "Registration Confirmation: #{title}’s Pipeline",
        global_merge_vars: brand_vars + [
           { name: 'registration_url', content: new_user_registration_url(invite_token: invite.token) },
        ]
    }
    send_message(template, [], message)
  end

end
