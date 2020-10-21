class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.date :date
      t.time :time
      t.string :pic
      t.boolean :private
      t.boolean :editable

      t.timestamps
    end
  end
end
