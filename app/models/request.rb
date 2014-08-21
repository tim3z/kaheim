class Request < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :user

  scope :current, -> { where('requests.updated_at >= ?', 31.days.ago) }
  scope :outdated, -> { where('requests.updated_at < ?', 31.days.ago) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }

  enum gender: { dontcare: 0, female: 1, male: 2 }
end
