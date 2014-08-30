class AnswersController < ApplicationController
  def create
    @answer = Answer.new(params[:answer].permit(:message, :mail, :item_id, :item_type))

    unless user_signed_in? || verify_recaptcha
      flash[:error] = t('recaptcha.errors.verification_failed')
      handle_error
      return false
    end

    if @answer.save
      UserMailer.answer_mail(@answer).deliver
      redirect_to @answer.item, notice: t('answers.success')
    else
      handle_error
    end
  end

  private

    def handle_error
      if @answer.item.class == Request
        @request = @answer.item
        render 'requests/show'
      elsif @answer.item.class == Offer
        @offer = @answer.item
        render 'offers/show'
      else
        redirect_to :back, flash: { error: 'Invalid params'}
      end
    end
end
