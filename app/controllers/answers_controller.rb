class AnswersController < ApplicationController
  before_action :block_spam, only: [:create]

  def create
    @answer = Answer.new(answer_params)
    @answer.save or (render_item and return)
    ItemMailer.answer_mail(@answer).deliver_now
    ItemMailer.answer_mail_notification(@answer).deliver_now
    redirect_to @answer.item, notice: t('answers.success')
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_params
    params[:answer].permit(:message, :mail, :item_id, :item_type)
  end

  def block_spam
    unless (user_signed_in? && current_user.confirmed?) || verify_captcha
      flash[:error] = t('captcha.errors.verification_failed')
      render_item
    end
  end

  def render_item
    @answer ||= Answer.new(answer_params)
    if @answer.item_type == Request.to_s
      @request = @answer.item
      render 'requests/show'
    elsif @answer.item_type == Offer.to_s
      @offer = @answer.item
      render 'offers/show'
    else
      redirect_back(fallback_location: root_path, flash: { error: 'Invalid params' })
    end
  end
end
