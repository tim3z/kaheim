module Item
  def self.included(base)
    base.extend(ClassMethods)

    base.belongs_to :user
    base.validates_presence_of :user
    base.has_many :answers, as: :item, dependent: :destroy

    base.scope :unlocked, -> { base.joins(:user).where(users: { unlocked: true }) }
    base.scope :locked, -> { base.joins(:user).where(users: { unlocked: false }) }
    base.scope :confirmed, -> { base.joins(:user).where.not(users: { confirmed_at: nil }) }
    base.scope :current, -> { base.where("#{base.table_name}.updated_at >= ?", base.outdating_date) }
    base.scope :outdated, -> { base.where("#{base.table_name}.updated_at < ?", base.outdating_date) }
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

  module ClassMethods
    def outdating_date
      31.days.ago
    end

    def visible_for(user = nil)
      return all if user.try :admin?
      query = current.unlocked.confirmed
      query = query.or(where(user: user)) if user
      query
    end
  end
end