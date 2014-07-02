class AddUnlockedToUser < ActiveRecord::Migration
  def change
    add_column :users, :unlocked, :boolean, null: false, default: false
  end
end
