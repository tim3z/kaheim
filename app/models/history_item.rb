class HistoryItem < ApplicationRecord
  validates_presence_of :offers_count, :requests_count
end
