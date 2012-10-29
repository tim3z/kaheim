class AnswersController < ApplicationController
  def create
    if verify_recaptcha
      UserMailer.answer_mail(params[:type].to_class.find(params[:id]), params[:message], params[:mail]).deliver
      flash[:message] = t 'answers.success'
    else
      flash[:alert] = t 'recaptcha.errors.verification_failed'
    end
    redirect_to :back
  end
end
