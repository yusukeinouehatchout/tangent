class AddColumnContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :name, :string
    add_column :contracts, :pass, :string
  end
end
