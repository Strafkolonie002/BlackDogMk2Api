# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_22_315344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "barcodes", force: :cascade do |t|
    t.string "barcode_number", null: false
    t.string "item_code", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["barcode_number"], name: "index_barcodes_on_barcode_number", unique: true
    t.index ["item_id"], name: "index_barcodes_on_item_id"
  end

  create_table "containers", force: :cascade do |t|
    t.string "container_code", null: false
    t.string "container_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["container_code"], name: "index_containers_on_container_code", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "item_code", null: false
    t.string "item_name", null: false
    t.boolean "inspection", null: false
    t.integer "creation_unit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_code"], name: "index_items_on_item_code", unique: true
  end

  create_table "materials", force: :cascade do |t|
    t.bigint "receive_order_detail_id"
    t.bigint "ship_order_detail_id"
    t.bigint "item_id"
    t.string "material_status", null: false
    t.bigint "container_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["container_id"], name: "index_materials_on_container_id"
    t.index ["item_id"], name: "index_materials_on_item_id"
    t.index ["receive_order_detail_id"], name: "index_materials_on_receive_order_detail_id"
    t.index ["ship_order_detail_id"], name: "index_materials_on_ship_order_detail_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_order_details_on_item_id"
    t.index ["order_id"], name: "index_order_details_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "slip_number", null: false
    t.string "order_type", null: false
    t.string "order_status", null: false
    t.jsonb "order_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slip_number"], name: "index_orders_on_slip_number", unique: true
  end

  add_foreign_key "barcodes", "items"
  add_foreign_key "materials", "containers"
  add_foreign_key "materials", "items"
  add_foreign_key "materials", "order_details", column: "receive_order_detail_id"
  add_foreign_key "materials", "order_details", column: "ship_order_detail_id"
  add_foreign_key "order_details", "items"
  add_foreign_key "order_details", "orders"
end
