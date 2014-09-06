class Request < ActiveRecord::Base
  include Item

  validates_presence_of :title, :description, :gender
  validates_length_of :title, maximum: 140

  enum gender: { dontcare: 0, female: 1, male: 2 }
end
