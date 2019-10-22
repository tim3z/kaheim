class ItemReactivationController < ApplicationController
  def reactivate
    unless reactivator = ItemReactivator.find_by(token: params[:token])
      redirect_to root_path, flash: { error: t('reactivation.bad_token') }
      return false
    end

    reactivator.item.confirm_email! unless reactivator.item.email_confirmed?
    reactivator.item.touch
    reactivator.destroy

    # TODO redirect to owner_show would be better (is it secure to do so?)
    redirect_to reactivator.item, notice: tm('reactivation.success', reactivator.item.class)
  end
end
