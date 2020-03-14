class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  validates_presence_of :name

  scope :admin, -> { where admin: true }
  scope :unlocked, -> { where(unlocked: true) }
  scope :locked, -> { where(unlocked: false) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def unlock!
    update!(unlocked: true)
  end

  def lock!
    update!(unlocked: false)
  end

  def confirmed?
    confirmed_at != nil
  end
end
