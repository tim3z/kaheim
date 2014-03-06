class Request < ActiveRecord::Base
  #TODO attr_accessible :description, :title, :until

  belongs_to :user

  validates_presence_of :title, :until, :description, :user

  default_scope -> { where('requests.until >= ?', Date.today) }
end
