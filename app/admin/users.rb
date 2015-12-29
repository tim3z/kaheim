ActiveAdmin.register User do
  menu priority: 2

  index do
    column :name
    column :email
    column :unlocked
    column :admin
    column :confirmed_at
    actions default: true do |user|
      link_to( user.unlocked? ? 'Sperren' : 'Freischalten', user.unlocked? ? lock_admin_user_path(user) : unlock_admin_user_path(user), method: :put)
    end
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name, input_html: { disabled: true }
      f.input :email, input_html: { disabled: true }
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
    if user.confirmed?
      Subscription.offers.confirmed.each do |subscriber|
        user.offers.each do |offer|
          SubscriptionMailer.new_item_notification(offer, subscriber).deliver_later
        end
      end
      Subscription.requests.confirmed.each do |subscriber|
        user.requests.each do |request|
          SubscriptionMailer.new_item_notification(request, subscriber).deliver_later
        end
      end
    end
    redirect_to :back, { notice: t('users.lock.unlock_done') }
  end
end
