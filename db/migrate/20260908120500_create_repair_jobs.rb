class CreateRepairJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :repair_jobs do |t|
      t.bigint :bike_id, null: false
      t.bigint :customer_id, null: false
      t.bigint :received_by_staff_id, null: false
      t.date :promised_by
      t.string :status, null: false, default: "received"
      t.datetime :received_at, null: false
      t.datetime :ready_at
      t.datetime :picked_up_at

      t.timestamps
    end

    add_index :repair_jobs, :bike_id
    add_index :repair_jobs, :customer_id
    add_index :repair_jobs, :received_by_staff_id
    add_index :repair_jobs, :status
  end
end
