class AnswersController < ApplicationController
  before_action :block_spam, only: [:create]

  def create
    @answer = Answer.new(answer_params)
    @answer.save or (render_item and return)
    UserMailer.answer_mail(@answer).deliver
    UserMailer.answer_mail_notification(@answer).deliver
    redirect_to @answer.item, notice: t('answers.success')
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_params
    params[:answer].permit(:message, :mail, :item_id, :item_type)
  end

  def block_spam
    unless (user_signed_in? && current_user.confirmed?) || verify_recaptcha
      flash[:error] = t('recaptcha.errors.verification_failed')
      render_item
    end
  end

  def render_item
    @answer ||= Answer.new(answer_params)
    if @answer.item.class == Request
      @request = @answer.item
      render 'requests/show'
    elsif @answer.item.class == Offer
      @offer = @answer.item
      render 'offers/show'
    else
      redirect_to :back, flash: { error: 'Invalid params' }
    end
  end
end
