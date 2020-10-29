class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :text
      t.integer :recipient
      t.integer :sender

      t.timestamps
    end
  end
end
