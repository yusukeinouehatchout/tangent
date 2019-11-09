class AddContractIdToContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :contract_id, :string,     null: false, default: 0
  end
end
