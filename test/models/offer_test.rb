require 'test_helper'

class OfferTest < ActiveSupport::TestCase

  default_values = {title: 'Title', description: 'Description', from_date: '01-01-1970', rent: 250, size: 14, gender: 0, street: 'Street', zip_code: '12394'}

  test 'default_values work' do
    offer = Offer.new(default_values)
    offer.user = users(:david)
    offer.save!
  end

  test 'must have title' do
    offer = Offer.new(default_values.except(:title))
    offer.user = users(:david)
    assert_not offer.save
  end

  test 'must have description' do
    offer = Offer.new(default_values.except(:description))
    offer.user = users(:david)
    assert_not offer.save
  end

  test 'must have from_date' do
    offer = Offer.new(default_values.except(:from_date))
    offer.user = users(:david)
    assert_not offer.save
  end

  test 'must have size' do
    offer = Offer.new(default_values.except(:size))
    offer.user = users(:david)
    assert_not offer.save
  end

  test 'must have street' do
    offer = Offer.new(default_values.except(:street))
    offer.user = users(:david)
    assert_not offer.save
  end

  test 'must have zip_code' do
    offer = Offer.new(default_values.except(:zip_code))
    offer.user = users(:david)
    assert_not offer.save
  end

  test 'must have user' do
    offer = Offer.new(default_values)
    assert_not offer.save
  end

  test 'must have gender' do
    offer = Offer.new(default_values)
    offer.user = users(:david)
    offer.gender = nil
    assert_not offer.save
  end

  test 'title can have 140 characters' do
    offer = Offer.new(default_values.except(:title))
    offer.user = users(:david)
    offer.title = 'a' * 140
    assert offer.save
  end

  test "title can't be longer than 140 characters" do
    offer = Offer.new(default_values.except(:title))
    offer.user = users(:david)
    offer.title = 'a' * 141
    assert_not offer.save
  end


end