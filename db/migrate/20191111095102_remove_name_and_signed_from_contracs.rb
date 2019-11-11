class RemoveNameAndSignedFromContracs < ActiveRecord::Migration[5.2]
  def change
    remove_column :contracts, :name, :string
    remove_column :contracts, :signed, :boolean
  end
end
