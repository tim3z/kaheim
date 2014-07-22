class AddPublicAndPublicUntilToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :public, :boolean
    add_column :requests, :public_until, :datetime
  end
end
