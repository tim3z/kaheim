require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest

  test 'create answer gets rejected without captcha' do
    item = offers(:tworooms)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post answers_url, params: {answer: {message: 'test', mail: 'test@example.com', item_id: item.id, item_type: 'Offer'} }
    end
  end

  test 'creating answer sends two mails' do
    item = offers(:tworooms)
    assert_difference 'ActionMailer::Base.deliveries.size', +2 do
      post answers_url, params: {answer: {message: 'test', mail: 'test@example.com', item_id: item.id, item_type: 'Offer'}, stupid_captcha: 'Maria' }
    end
  end

end
