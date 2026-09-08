# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_09_08_120600) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bikes", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "brand", null: false
    t.string "model", null: false
    t.string "serial_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_bikes_on_customer_id"
    t.index ["serial_number"], name: "index_bikes_on_serial_number", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_lists", force: :cascade do |t|
    t.integer "year", null: false
    t.date "effective_from", null: false
    t.date "effective_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_price_lists_on_year", unique: true
  end

  create_table "repair_jobs", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "received_by_staff_id", null: false
    t.date "promised_by"
    t.string "status", default: "received", null: false
    t.datetime "received_at", null: false
    t.datetime "ready_at"
    t.datetime "picked_up_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_repair_jobs_on_bike_id"
    t.index ["customer_id"], name: "index_repair_jobs_on_customer_id"
    t.index ["received_by_staff_id"], name: "index_repair_jobs_on_received_by_staff_id"
    t.index ["status"], name: "index_repair_jobs_on_status"
  end

  create_table "repair_line_items", force: :cascade do |t|
    t.bigint "repair_job_id", null: false
    t.bigint "service_catalogue_item_id", null: false
    t.decimal "quoted_price", precision: 8, scale: 2
    t.decimal "actual_price", precision: 8, scale: 2
    t.boolean "approved_by_customer"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repair_job_id"], name: "index_repair_line_items_on_repair_job_id"
    t.index ["service_catalogue_item_id"], name: "index_repair_line_items_on_service_catalogue_item_id"
  end

  create_table "service_catalogue_items", force: :cascade do |t|
    t.bigint "price_list_id", null: false
    t.string "name", null: false
    t.decimal "list_price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_list_id", "name"], name: "index_service_catalogue_items_on_price_list_id_and_name", unique: true
    t.index ["price_list_id"], name: "index_service_catalogue_items_on_price_list_id"
  end

  create_table "staff_members", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
