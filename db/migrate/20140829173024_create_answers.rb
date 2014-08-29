class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :mail
      t.text :message
      t.references :item, index: true, polymorphic: true

      t.timestamps
    end
  end
end
