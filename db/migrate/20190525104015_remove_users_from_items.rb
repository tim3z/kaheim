class RemoveUsersFromItems < ActiveRecord::Migration[6.0]
  class Offer < ApplicationRecord
    belongs_to :user
  end
  class Request < ApplicationRecord
    belongs_to :user
  end

  def change
    add_column :offers, :owner_name, :string
    add_column :requests, :owner_name, :string
    add_column :offers, :email, :string
    add_column :requests, :email, :string

    add_column :offers, :blocked, :boolean, default: false, null: false
    add_column :requests, :blocked, :boolean, default: false, null: false
    add_column :offers, :email_confirmed_at, :datetime
    add_column :requests, :email_confirmed_at, :datetime

    reversible do |dir|
      dir.up do
        [Offer, Request].each do |item_class|
          item_class.all.each do |item|
            item.owner_name = item.user.name
            item.email = item.user.email
            item.email_confirmed_at = item.user.confirmed_at
            item.blocked = true unless item.user.unlocked
            item.save!(touch: false)
          end
        end
      end

      dir.down do
        puts '😢'
        raise ActiveRecord::IrreversibleMigration
      end
    end

    change_column_null :offers, :owner_name, false
    change_column_null :requests, :owner_name, false
    change_column_null :offers, :email, false
    change_column_null :requests, :email, false

    remove_column :offers, :user_id, :integer, null: false, default: 0
    remove_column :requests, :user_id, :integer, null: false, default: 0
  end
end
