class HistoryItem < ActiveRecord::Base
  validates_presence_of :offers_count, :requests_count
end
