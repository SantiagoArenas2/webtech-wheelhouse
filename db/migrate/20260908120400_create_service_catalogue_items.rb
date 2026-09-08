class CreateServiceCatalogueItems < ActiveRecord::Migration[8.0]
  def change
    create_table :service_catalogue_items do |t|
      t.bigint :price_list_id, null: false
      t.string :name, null: false
      t.decimal :list_price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :service_catalogue_items, :price_list_id
    add_index :service_catalogue_items, [ :price_list_id, :name ],
      unique: true,
      name: "index_service_catalogue_items_on_price_list_id_and_name"
  end
end
