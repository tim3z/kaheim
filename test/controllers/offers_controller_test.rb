require 'test_helper'

class OffersControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get offers_url
    assert_response :success
    assert_select 'table.offer-specifics', 1
  end

  # test 'does not send notification if unlocked but unconfirmed user creates offer' do
  #   user = users(:jane)
  #   assert user.unlocked
  #   assert_not user.confirmed?
  #   sign_in user
  #   assert_difference 'ActionMailer::Base.deliveries.size', +1 do
  #     post offers_url, params: {offer: { title: 'New offer', description: 'An offer you cannot refuse', from_date: '01-01-2013', rent: 200, size: 19, gender: 'dontcare', street: 'Sesame', zip_code: '12949' }}
  #   end
  #   assert_equal I18n.t('helpers.creation_success_confirmation_required', {model: Offer.model_name.human}), flash[:alert]
  #   sent_mail = ActionMailer::Base.deliveries.last
  #   assert sent_mail.subject.include?(I18n.t('devise.mailer.confirmation_instructions.subject'))
  #   assert sent_mail.body.include?("confirmation")
  # end
  #
  # test 'send notification if unlocked and confirmed user creates offer' do
  #   user = users(:maren)
  #   assert user.unlocked
  #   assert user.confirmed?
  #   sign_in user
  #   num_subscribers = Subscription.offers.confirmed.count
  #   assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
  #     post offers_url, params: {offer: { title: 'New offer', description: 'An offer you cannot refuse', from_date: '01-01-2013', rent: 200, size: 19, gender: 'dontcare', street: 'Sesame', zip_code: '12949' }}
  #   end
  #   assert_equal I18n.t('helpers.creation_success', {model: Offer.model_name.human}), flash[:notice]
  # end

  test 'unlocking offer sends notifications to subscribers' do
    # TODO
  end

end
