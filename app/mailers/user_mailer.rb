class UserMailer < ActionMailer::Base
  default from: "no-reply@je-ka-wg.herokuapp.com"

  def answer_mail subject, content, reply_to
    @content = content
    mail to: subject.user.email, subject: "Answer on #{subject.title}", reply_to: reply_to
  end
end
