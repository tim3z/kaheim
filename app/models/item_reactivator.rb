class ItemReactivator < ApplicationRecord
  belongs_to :item, polymorphic: true
  validates :token, uniqueness: true, presence: true
  validates_presence_of :item

  before_validation :generate_token, on: :create

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless ItemReactivator.exists?(token: random_token)
    end
  end
end
