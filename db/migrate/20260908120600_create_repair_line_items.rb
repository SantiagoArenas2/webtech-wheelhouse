class CreateRepairLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :repair_line_items do |t|
      t.bigint :repair_job_id, null: false
      t.bigint :service_catalogue_item_id, null: false
      t.decimal :quoted_price, precision: 8, scale: 2
      t.decimal :actual_price, precision: 8, scale: 2
      t.boolean :approved_by_customer
      t.text :notes

      t.timestamps
    end

    add_index :repair_line_items, :repair_job_id
    add_index :repair_line_items, :service_catalogue_item_id
  end
end
