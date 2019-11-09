class AddSignedToContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :signed, :boolean,     null: false, default: false
  end
end
