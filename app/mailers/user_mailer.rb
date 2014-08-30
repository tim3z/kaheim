class UserMailer < ActionMailer::Base
  default from: "no-reply@kaheim.de"

  def answer_mail answer
    @content = answer.message
    mail to: answer.item.user.email, subject: t('user_mailer.answer_mail.subject', title: answer.item.title), reply_to: answer.mail
  end

  def reactivate_item_mail item, token
  	@item = item
    @token = token
  	mail to: item.user.email
  end

  def admin_notice_mail item, admin
    @item = item
    mail to: admin.email, subject: 'Nicht freigeschaltetes Item'
  end
end
