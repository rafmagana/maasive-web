class InviteRequestMailer < ActionMailer::Base

  def request_received_email(invite)
    @invite = invite
    mail(:to => invite.email, :subject => "[MaaSive] Request received!")
  end

end
