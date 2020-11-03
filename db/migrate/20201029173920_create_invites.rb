class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.integer :event_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
