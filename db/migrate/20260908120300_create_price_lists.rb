class CreatePriceLists < ActiveRecord::Migration[8.0]
  def change
    create_table :price_lists do |t|
      t.integer :year, null: false
      t.date :effective_from, null: false
      t.date :effective_to

      t.timestamps
    end

    add_index :price_lists, :year, unique: true
  end
end
