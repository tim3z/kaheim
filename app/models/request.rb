class Request < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :user

  scope :current, -> { where('requests.public_until >= ?', Date.today) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }
end
