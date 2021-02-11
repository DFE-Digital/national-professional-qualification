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

ActiveRecord::Schema.define(version: 2021_02_09_114413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :user_roles, [
    "admin",
    "supplier",
  ], force: :cascade

  create_table "orders", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "product_item_id"
    t.string "teacher_reference_number"
    t.string "state"
    t.integer "price_pence", default: 0
    t.integer "amount_paid_pence", default: 0
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["product_item_id"], name: "index_orders_on_product_item_id"
  end

  create_table "product_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_items_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.string "name"
    t.date "start_at"
    t.date "end_at"
    t.integer "quantity"
    t.integer "availability"
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_pence", default: 0
    t.integer "total_value_pence", default: 0
    t.string "state"
    t.index ["approved_by_id"], name: "index_products_on_approved_by_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "statement_orders", force: :cascade do |t|
    t.bigint "statement_id"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_statement_orders_on_order_id"
    t.index ["statement_id"], name: "index_statement_orders_on_statement_id"
  end

  create_table "statements", force: :cascade do |t|
    t.integer "amount_pence", default: 0, null: false
    t.string "amount_currency", default: "GBP", null: false
    t.date "scheduled_at"
    t.string "reason"
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_statements_on_product_id"
  end

  create_table "supplier_members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "supplier_id"
    t.index ["supplier_id"], name: "index_supplier_members_on_supplier_id"
    t.index ["user_id"], name: "index_supplier_members_on_user_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
    t.string "unique_reference_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "source_id"
    t.enum "role", enum_name: "user_roles"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "product_items", "products"
  add_foreign_key "products", "suppliers"
  add_foreign_key "products", "users", column: "approved_by_id"
  add_foreign_key "statements", "products"
  add_foreign_key "supplier_members", "suppliers"
  add_foreign_key "supplier_members", "users"
end
