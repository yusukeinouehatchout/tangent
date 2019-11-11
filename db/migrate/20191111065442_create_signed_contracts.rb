class CreateSignedContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :signed_contracts do |t|
      t.timestamps

      t.references :templete,        foreign_key: { to_table: :contracts }, null: false, default: 0
      t.references :user,            null: false, default: 0, foreign_key: true
      t.text :pdf_data,              null: false
      t.string :name,                null: false, default: ""
    end
  end
end
