class CreateAttendings < ActiveRecord::Migration[6.0]
  def change
    create_table :attendings do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
