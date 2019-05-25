require 'test_helper'

class OfferTest < ActiveSupport::TestCase

  default_values = {title: 'Title', description: 'Description', from_date: '01-01-1970', rent: 250, size: 14,
                    gender: 0, street: 'Street', zip_code: '12394', owner_name: 'Owner', email: 'owner@example.com'}

  test 'default_values work' do
    offer = Offer.new(default_values)
    offer.save!
  end

  test 'must have title' do
    offer = Offer.new(default_values.except(:title))
    assert_not offer.save
  end

  test 'must have description' do
    offer = Offer.new(default_values.except(:description))
    assert_not offer.save
  end

  test 'must have from_date' do
    offer = Offer.new(default_values.except(:from_date))
    assert_not offer.save
  end

  test 'must have size' do
    offer = Offer.new(default_values.except(:size))
    assert_not offer.save
  end

  test 'must have gender' do
    offer = Offer.new(default_values)
    offer.gender = nil
    assert_not offer.save
  end

  test 'must have street' do
    offer = Offer.new(default_values.except(:street))
    assert_not offer.save
  end

  test 'must have zip_code' do
    offer = Offer.new(default_values.except(:zip_code))
    assert_not offer.save
  end

  test 'must have owner_name' do
    offer = Offer.new(default_values.except(:owner_name))
    assert_not offer.save
  end

  test 'must have email' do
    offer = Offer.new(default_values.except(:email))
    assert_not offer.save
  end

  test 'title can have 140 characters' do
    offer = Offer.new(default_values.except(:title))
    offer.title = 'a' * 140
    assert offer.save
  end

  test "title can't be longer than 140 characters" do
    offer = Offer.new(default_values.except(:title))
    offer.title = 'a' * 141
    assert_not offer.save
  end


end