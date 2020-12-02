class AddCoordsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lat, :float
    add_column :users, :lng, :float
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :events, :lat, :float
    add_column :events, :lng, :float
    add_column :events, :street, :string
    add_column :events, :city, :string
    add_column :events, :state, :string
    add_column :events, :country, :string
  end
end
