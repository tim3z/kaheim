class Offer < ActiveRecord::Base
  attr_accessible :description, :title, :until

  belongs_to :user

  validates_presence_of :title, :until, :description, :user

  scope :active, where('offers.until >= ?', Date.today)
end
