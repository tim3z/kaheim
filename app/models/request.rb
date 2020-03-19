class Request < ApplicationRecord
  include Item

  validates_presence_of :title, :description, :gender
  validates_length_of :title, maximum: 140

  validates :description, format: { with: /.+\s.+/, message: "at least two words" }

  enum gender: { dontcare: 0, female: 1, male: 2 }
end
