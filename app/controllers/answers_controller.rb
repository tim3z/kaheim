class AnswersController < ApplicationController
  def create
    UserMailer.answer_mail(params[:type].constantize.find(params[:id]), params[:message], params[:mail]).deliver
    redirect_to :back
  end
end
