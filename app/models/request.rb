class Request < ActiveRecord::Base
  attr_accessible :description, :title, :until
end
