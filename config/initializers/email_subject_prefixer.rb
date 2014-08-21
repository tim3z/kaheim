class PrefixEmailSubject
  def self.delivering_email(mail)
    mail.subject = "[Kaheim] " + mail.subject
  end
end
ActionMailer::Base.register_interceptor(PrefixEmailSubject)