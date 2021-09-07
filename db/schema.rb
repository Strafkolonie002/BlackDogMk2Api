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

ActiveRecord::Schema.define(version: 2021_09_06_071038) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.jsonb "item_properties", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_code"], name: "index_items_on_item_code", unique: true
  end

  create_table "material_states", force: :cascade do |t|
    t.string "material_state_code"
    t.string "material_state_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["material_state_code"], name: "index_material_states_on_material_state_code", unique: true
  end

  create_table "materials", force: :cascade do |t|
    t.string "item_code", null: false
    t.string "material_state_code", null: false
    t.string "container_code"
    t.jsonb "material_properties", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "post_actions", force: :cascade do |t|
    t.string "post_action_code", null: false
    t.string "post_action_name", null: false
    t.string "method_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_action_code"], name: "index_post_actions_on_post_action_code", unique: true
  end

  create_table "task_details", force: :cascade do |t|
    t.string "task_code"
    t.integer "task_detail_number"
    t.string "material_property_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "task_code", null: false
    t.string "task_name", null: false
    t.string "search_properties", default: [], null: false, array: true
    t.string "dest_material_state_code"
    t.string "post_action_code"
    t.jsonb "task_properties", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_code"], name: "index_tasks_on_task_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "user_code", null: false
    t.string "user_name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_code"], name: "index_users_on_user_code", unique: true
  end

end
