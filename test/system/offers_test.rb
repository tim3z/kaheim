require "application_system_test_case"

SimpleCov.command_name "test:system"

class OffersTest < ApplicationSystemTestCase

  test "title is shown" do
    offer = offers(:tworooms)
    visit offers_url(offer)

    assert_selector '.title', text: offer.title
  end

end
