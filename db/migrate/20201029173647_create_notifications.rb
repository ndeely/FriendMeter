class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :title
      t.string :desc
      t.integer :sender_id

      t.timestamps
    end
  end
end
