class UserMailer < ActionMailer::Base
  default from: "no-reply@kaheim.de"

  def answer_mail subject, content, reply_to
    @content = content
    mail to: subject.user.email, subject: t('user_mailer.answer_mail.subject', :title => subject.title), reply_to: reply_to
  end

  def reactivate_item_mail item, token
  	@item = item
    @token = token
  	mail to: item.user.email
  end
end
