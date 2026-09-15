class AddForeignKeysToWheelhouseTables < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :bikes, :customers

    add_foreign_key :repair_jobs, :bikes
    add_foreign_key :repair_jobs, :customers
    add_foreign_key :repair_jobs, :staff_members, column: :received_by_staff_id

    add_foreign_key :service_catalogue_items, :price_lists

    add_foreign_key :repair_line_items, :repair_jobs
    add_foreign_key :repair_line_items, :service_catalogue_items
  end
end
