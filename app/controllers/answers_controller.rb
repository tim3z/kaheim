class AnswersController < ApplicationController
  def create
    unless user_signed_in? || verify_recaptcha
      redirect_to :back, flash: { alert: t('recaptcha.errors.verification_failed') }
      return false
    end

    UserMailer.answer_mail(params[:type].constantize.find(params[:id]), params[:message], params[:mail]).deliver
    redirect_to :back, notice: t('answers.success')
  end
end
