class Subscription < ApplicationRecord

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :confirmation_token, uniqueness: { allow_blank: true, allow_nil: true }
  validates :unsubscribe_token, uniqueness: true

  before_validation :generate_tokens!, on: :create

  scope :confirmed, -> { where(confirmation_token: [nil, '']) }
  scope :offers, -> { where(offers: true) }
  scope :requests, -> { where(requests: true) }

  def generate_tokens!
    self.confirmation_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      Subscription.exists?(confirmation_token: random_token) or break random_token
    end
    self.unsubscribe_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      Subscription.exists?(unsubscribe_token: random_token) or break random_token
    end
  end

  def confirmed?
    confirmation_token.blank?
  end

  def confirm!
    update!(confirmation_token: nil)
  end

  def subscribed_types
    return 'all' if offers? && requests?
    return 'requests' if requests?
    return 'offers' if offers?
    nil
  end

end
