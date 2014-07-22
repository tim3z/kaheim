class AddPublicAndPublicUntilToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :public, :boolean
    add_column :offers, :public_until, :datetime
  end
end
