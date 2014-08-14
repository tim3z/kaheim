class Offer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :user

  scope :current, -> { where('offers.updated_at >= ?', 31.days.ago) }
  scope :outdated, -> { where('offers.updated_at < ?', 31.days.ago) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }
end
