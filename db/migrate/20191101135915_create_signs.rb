class CreateSigns < ActiveRecord::Migration[5.2]
  def change
    create_table :signs do |t|
      t.text        :image_data, null: false

      t.timestamps
    end
  end
end
