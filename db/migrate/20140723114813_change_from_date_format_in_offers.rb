class ChangeFromDateFormatInOffers < ActiveRecord::Migration
  def change
    change_column :offers, :from_date, :date
  end
end
