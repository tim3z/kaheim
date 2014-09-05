class Request < ActiveRecord::Base
  belongs_to :user
  has_many :answers, as: :item, dependent: :destroy

  validates_presence_of :title, :description, :user, :gender

  scope :current, -> { where('requests.updated_at >= ?', 31.days.ago) }
  scope :outdated, -> { where('requests.updated_at < ?', 31.days.ago) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }
  scope :locked, -> { joins(:user).where(users: { unlocked: false }) }

  validates_length_of :title, maximum: 140

  enum gender: { dontcare: 0, female: 1, male: 2 }

  def current?
    updated_at >= 31.days.ago
  end
  def outdated?
    updated_at < 31.days.ago
  end
  def visible?
    user.unlocked? && current?
  end

  def self.visible_for(user = nil)
    query = current.unlocked
    query.or(where(user: user)) if user
    query
  end
end
