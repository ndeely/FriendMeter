class CreateFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :friends do |t|
      t.integer :f1
      t.integer :f2

      t.timestamps
    end
  end
end
