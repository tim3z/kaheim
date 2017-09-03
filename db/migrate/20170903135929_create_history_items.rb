class CreateHistoryItems < ActiveRecord::Migration
  def change
    create_table :history_items do |t|
      t.integer :offers_count
      t.integer :requests_count

      t.timestamps null: false
    end
  end
end
