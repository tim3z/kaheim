class Offer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :until, :description, :user

  default_scope -> { where('offers.until >= ?', Date.today) }
end
