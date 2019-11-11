class CreateSignedContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :signed_contracts do |t|
      t.timestamps

      t.integer :templete_id,        null: false, default: 0
      t.references :user,            null: false, default: 0
      t.text :pdf_data,              null: false
      t.string :name,                null: false, default: ""
    end
  end
end
