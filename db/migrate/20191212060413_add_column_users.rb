class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string,      null: false, default: ""
    add_column :users, :belongs, :string,   null: false, default: ""    # 所属している会社・部署・支店・店舗等
  end
end
