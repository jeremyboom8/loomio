class Events::InvitationResend < Event
  def self.publish!(invitation)
    super(invitation, user: invitation.inviter, announcement: true)
  end

  def poll
    eventable.group.invitation_target
  end

  def trigger!
    super
    eventable.mailer.delay(priority: 1).invitation_resend(eventable, self)
    eventable.increment!(:send_count)
  end
end
