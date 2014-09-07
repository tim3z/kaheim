class Subscription < ActiveRecord::Base

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :confirmation_token, uniqueness: { allow_blank: true, allow_nil: true }

  before_validation :generate_token!, on: :create

  scope :active, where("confirmation_token is null or confirmation_token = ''")

  def generate_token!
    self.confirmation_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      Subscription.exists?(confirmation_token: random_token) or break random_token
    end
  end

  def active?
    confirmation_token.blank?
  end

  def activate!
    self.confirmation_token = nil
  end

end
