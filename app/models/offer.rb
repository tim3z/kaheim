class Offer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :until, :description, :user

  scope :current, -> { where('offers.until >= ?', Date.today) }
end
