class Request < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :until, :description, :user

  scope :current, -> { where('requests.until >= ?', Date.today) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }
end
