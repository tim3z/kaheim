class AddAddressFieldsToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :district, :string
    add_column :offers, :street, :string
    add_column :offers, :zip_code, :string
  end
end
