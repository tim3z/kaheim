require 'test_helper'

class OffersControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get offers_url
    assert_response :success
    assert_select 'table.offer-specifics', 1
  end

  test 'unlocking offer sends notifications to subscribers' do
    offer = offers(:roommate_wanted)
    assert_not offer.email_confirmed?
    num_subscribers = Subscription.offers.confirmed.count
    assert num_subscribers > 0
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      get owner_show_offer_url(offer, token: offer.owner_show_token)
    end
    assert offer.reload.email_confirmed?
  end

end
