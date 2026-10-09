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

ActiveRecord::Schema[8.1].define(version: 2026_10_09_052411) do
  create_table "bookings", force: :cascade do |t|
    t.integer "trip_id", null: false
    t.integer "user_id", null: false
    t.string "passenger_name", null: false
    t.string "passenger_document", null: false
    t.integer "seat_number", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id", "seat_number"], name: "index_bookings_on_trip_id_and_seat_number", unique: true, where: "status <> 2"
    t.index ["trip_id"], name: "index_bookings_on_trip_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cities_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "departure_at", null: false
    t.decimal "fare", precision: 10, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.integer "vehicle_id", null: false
    t.integer "origin_id", null: false
    t.integer "destination_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["departure_at"], name: "index_trips_on_departure_at"
    t.index ["destination_id"], name: "index_trips_on_destination_id"
    t.index ["origin_id"], name: "index_trips_on_origin_id"
    t.index ["vehicle_id"], name: "index_trips_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate", null: false
    t.string "driver", null: false
    t.integer "kind", default: 0, null: false
    t.integer "capacity", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plate"], name: "index_vehicles_on_plate", unique: true
  end

  add_foreign_key "bookings", "trips"
  add_foreign_key "bookings", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "trips", "cities", column: "destination_id"
  add_foreign_key "trips", "cities", column: "origin_id"
  add_foreign_key "trips", "vehicles"
end
