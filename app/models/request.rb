class Request < ApplicationRecord
  include Item

  validates_presence_of :title, :description, :gender
  validates_length_of :title, maximum: 140
  validate :is_not_spam?, on: :create

  validates :description, format: { with: /.+\s.+/, message: "at least two words" }

  enum gender: { dontcare: 0, female: 1, male: 2 }

  attr_accessor :no_spam

  def is_not_spam?
    errors.add(:no_spam, I18n.t('errors.messages.accepted')) unless no_spam == '1'
  end
end
