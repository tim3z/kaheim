class Offer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :user, :from_date

  scope :current, -> { where('offers.to_date >= ?', Date.today) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }
end
