class Offer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :user, :from_date, :rent, :size, :gender, :district, :street, :zip_code

  scope :current, -> { where('offers.updated_at >= ?', 31.days.ago) }
  scope :outdated, -> { where('offers.updated_at < ?', 31.days.ago) }
  scope :unlocked, -> { joins(:user).where(users: { unlocked: true }) }

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
end
