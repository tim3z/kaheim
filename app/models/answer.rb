class Answer < ApplicationRecord
  validates_presence_of :message, :item, :mail
  validates_format_of :mail, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  belongs_to :item, polymorphic: true
end
