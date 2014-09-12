class ConfirmationsController < Devise::ConfirmationsController

  def show
    confirmation_token = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
    old_resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    old_email = old_resource.email
    super
    if self.resource.email != old_email
      subscription = Subscription.find_by_email(old_email)
      if subscription
        subscription.email = self.resource.email
        subscription.save!
      end
    end
    subscription = Subscription.find_by_email(self.resource.email)
    subscription.confirm! if subscription
  end

end