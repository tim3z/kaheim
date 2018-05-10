class Offer < ApplicationRecord
  include Item

  validates_presence_of :title, :description, :from_date, :rent, :size, :gender, :street, :zip_code
  validates_length_of :title, maximum: 140

  enum gender: { dontcare: 0, female: 1, male: 2 }
end
