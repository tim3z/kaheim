require 'active_support/concern'

module CreationSpamCheck
  extend ActiveSupport::Concern

  included do
    validate :is_not_spam?, on: :create
    attr_accessor :no_spam
  end

  def is_not_spam?
    errors.add(:no_spam, I18n.t('errors.messages.accepted')) unless no_spam == '1'
  end

end
