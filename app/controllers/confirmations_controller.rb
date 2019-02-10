class ConfirmationsController < Devise::ConfirmationsController

  def show
    old_resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if old_resource.errors.any?
      confirmation_token = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
      old_resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    end
    old_email = old_resource.email
    old_confirmed_at = old_resource.confirmed_at
    super
    # if old_resource.errors.any?
    #   return
    # end
    # update existing subscription if the user confirmed a new email address
    if self.resource.email != old_email
      subscription = Subscription.find_by_email(old_email)
      if subscription
        subscription.email = self.resource.email
        subscription.save!
      end
    end
    # send notifications about a user's items if the user confirms their email address for the first time
    if old_confirmed_at == nil && self.resource.unlocked?
      user = self.resource
      Subscription.offers.confirmed.each do |subscriber|
        user.offers.is_public.each do |offer|
          SubscriptionMailer.new_item_notification(offer, subscriber).deliver_now
        end
      end
      Subscription.requests.confirmed.each do |subscriber|
        user.requests.is_public.each do |request|
          SubscriptionMailer.new_item_notification(request, subscriber).deliver_now
        end
      end
    end
    subscription = Subscription.find_by_email(self.resource.email)
    subscription.confirm! if subscription
  end

end
