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

ActiveRecord::Schema.define(version: 2020_04_25_120354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accountings", force: :cascade do |t|
    t.integer "dish_count", default: 0
    t.integer "restaurant_count", default: 0
    t.integer "singleton_guard", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["singleton_guard"], name: "index_accountings_on_singleton_guard", unique: true
  end

  create_table "dishes", force: :cascade do |t|
    t.string "title"
    t.float "price"
    t.string "description"
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "city"
    t.string "zip_code"
    t.string "street"
    t.string "department"
    t.string "tags", default: [], array: true
    t.string "text", default: [], array: true
    t.float "latitude"
    t.float "longitude"
    t.string "source"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
