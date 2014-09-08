ActiveAdmin.register User do
  menu priority: 2

  index do
    column :name
    column :email
    column :unlocked
    column :admin
    column :confirmed_at
    actions
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name, input_html: { disabled: true }
      f.input :email, input_html: { disabled: true }
      f.input :unlocked
      f.input :admin
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:unlocked, :admin]
    end
  end

  member_action :lock, method: :put do
    User.find(params[:id]).lock!
    redirect_to :back, { notice: t('users.lock.lock_done') }
  end
  member_action :unlock, method: :put do
    user = User.find(params[:id])
    user.unlock!
    Subscription.offers.active.each do |subscriber|
      user.offers.each do |offer|
        SubscriptionMailer.new_item_notification(offer, subscriber)
      end
    end
    Subscription.requests.active.each do |subscriber|
      user.requests.each do |request|
        SubscriptionMailer.new_item_notification(request, subscriber)
      end
    end
    redirect_to :back, { notice: t('users.lock.unlock_done') }
  end
end
