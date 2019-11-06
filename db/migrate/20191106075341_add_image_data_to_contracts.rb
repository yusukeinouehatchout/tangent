class AddImageDataToContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :pdf_data, :text
  end
end
