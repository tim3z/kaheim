class AddGenderDefaultToOffersAndRequests < ActiveRecord::Migration
  def change
    change_column :offers, :gender, :integer, :default => 0
    change_column :requests, :gender, :integer, :default => 0
  end
end
