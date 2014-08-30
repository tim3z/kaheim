class Offer < ActiveRecord::Base
  belongs_to :user
  has_many :answers, as: :item, dependent: :destroy

  validates_presence_of :title, :description, :user, :from_date, :rent, :size, :gender, :street, :zip_code

  scope :current, -> { where('offers.updated_at >= ?', 31.days.ago) }
  scope :outdated, -> { where('offers.updated_at < ?', 31.days.ago) }
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

  def district_or_karlsruhe
    district || 'Karlsruhe'
  end
end
