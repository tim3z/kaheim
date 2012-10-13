class AddUserToOfferAndRequest < ActiveRecord::Migration
  def change
    add_column :offers, :user_id, :integer, null: false, default: 0
    add_column :requests, :user_id, :integer, null: false, default: 0
  end
end
