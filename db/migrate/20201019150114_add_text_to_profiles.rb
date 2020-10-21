class AddTextToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :text, :string
  end
end
