class Request < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :user, :gender

  scope :current, -> { where('requests.updated_at >= ?', 31.days.ago) }
  scope :outdated, -> { where('requests.updated_at < ?', 31.days.ago) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }

  validates_length_of :title, maximum: 140

  enum gender: { dontcare: 0, female: 1, male: 2 }
end
