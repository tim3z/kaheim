module SubscriptionsHelper
  def user_subscribed(user, item_type)
    subscription = Subscription.find_by_email(user.email) or return false
    case item_type
      when :requests
        return subscription.requests
      when :offers
        return subscription.offers
      else
        return false
    end
  end
end
