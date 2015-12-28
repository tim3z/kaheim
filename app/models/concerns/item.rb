require 'active_support/concern'

module Item
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    validates_presence_of :user
    has_many :answers, as: :item, dependent: :destroy
    has_one :item_reactivator, as: :item, dependent: :destroy

    scope :unlocked, -> { joins(:user).merge(User.unlocked) }
    scope :locked, -> { joins(:user).merge(User.locked) }
    scope :confirmed, -> { joins(:user).merge(User.confirmed) }
    scope :current, -> { where("#{table_name}.updated_at >= ?", outdating_date) }
    scope :outdated, -> { where("#{table_name}.updated_at < ?", outdating_date) }
    scope :is_public, -> { where(is_public: true) }
  end

  module ClassMethods
    def outdating_date
      31.days.ago
    end

    def visible_for(user = nil)
      return current.or(where(user: user)) if user.try :admin?
      query = current.unlocked.confirmed.is_public
      query = query.or(where(user: user)) if user
      query
    end
  end

  def current?
    updated_at >= self.class.outdating_date
  end

  def outdated?
    updated_at < self.class.outdating_date
  end

  def visible?
    user.unlocked? && user.confirmed? && current?
  end

  def get_or_create_reactivator
    return item_reactivator if item_reactivator
    ItemReactivator.create! item: self
  end
end
