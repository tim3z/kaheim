class AddActiveToItems < ActiveRecord::Migration
  def change
    add_column :offers, :active, :boolean, default: true
    add_column :requests, :active, :boolean, default: true
  end
end
