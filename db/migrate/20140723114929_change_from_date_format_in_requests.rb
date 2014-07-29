class ChangeFromDateFormatInRequests < ActiveRecord::Migration
  def change
    change_column :requests, :from_date, :date
  end
end
