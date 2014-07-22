class AddFieldsToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :rent, :integer
    add_column :offers, :size, :integer
    add_column :offers, :gender, :integer
    add_column :offers, :from_date, :datetime
    rename_column :offers, :until, :to_date
  end
end
