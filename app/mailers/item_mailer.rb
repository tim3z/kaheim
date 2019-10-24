class ItemMailer < ActionMailer::Base
  default from: "Kaheim <no-reply@kaheim.de>"

  def item_creation_mail item
    @item = item
    mail to: item.email, subject: t('item_mailer.item_creation_mail.subject', item_type: item.class.model_name.human)
  end

  def item_edit_link_mail item
    @item = item
    mail to: item.email, subject: t('item_mailer.item_edit_link_mail.subject', item_type: item.class.model_name.human)
  end

  def reactivate_item_mail item, token
    @item = item
    @token = token
    mail to: item.email
  end

  def answer_mail answer
    @content = answer.message
    @item = answer.item
    mail to: answer.item.email, subject: t('item_mailer.answer_mail.subject', title: answer.item.title), reply_to: answer.mail
  end

  def answer_mail_notification answer
    @content = answer.message
    @item = answer.item
    mail to: answer.mail, subject: t('item_mailer.answer_mail_notification.subject')
  end

  def admin_notice_mail item, admin
    @item = item
    mail to: admin.email, subject: 'Nicht freigeschaltetes Item'
  end

  def send_token_mail item
    @item = item
    mail from: "team@kaheim.de", to: item.email, subject: "Dein #{@item.class.model_name.human} auf Kaheim"
  end

end
