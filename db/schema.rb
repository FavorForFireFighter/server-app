# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150825213458) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "bus_operation_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bus_route_informations", force: :cascade do |t|
    t.integer  "bus_type_id"
    t.integer  "bus_operation_company_id"
    t.string   "bus_line_name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "bus_route_informations", ["bus_operation_company_id"], name: "index_bus_route_informations_on_bus_operation_company_id", using: :btree

  create_table "bus_stop_bus_route_informations", force: :cascade do |t|
    t.integer  "bus_stop_id"
    t.integer  "bus_route_information_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "bus_stop_bus_route_informations", ["bus_route_information_id"], name: "index_to_bus_route_information_id", using: :btree
  add_index "bus_stop_bus_route_informations", ["bus_stop_id"], name: "index_bus_stop_bus_route_informations_on_bus_stop_id", using: :btree

  create_table "bus_stop_photos", force: :cascade do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "bus_stop_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "bus_stop_photos", ["bus_stop_id"], name: "index_bus_stop_photos_on_bus_stop_id", using: :btree
  add_index "bus_stop_photos", ["user_id"], name: "index_bus_stop_photos_on_user_id", using: :btree

  create_table "bus_stops", force: :cascade do |t|
    t.string    "name"
    t.integer   "prefecture_id"
    t.geography "location",            limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "location_updated_at"
    t.integer   "last_modify_user_id"
    t.datetime  "created_at",                                                                   null: false
    t.datetime  "updated_at",                                                                   null: false
  end

  add_index "bus_stops", ["location"], name: "index_bus_stops_on_location", using: :gist
  add_index "bus_stops", ["name"], name: "index_bus_stops_on_name", using: :btree
  add_index "bus_stops", ["prefecture_id"], name: "index_bus_stops_on_prefecture_id", using: :btree

  create_table "prefectures", force: :cascade do |t|
    t.string    "name"
    t.geography "location",   limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at",                                                          null: false
    t.datetime  "updated_at",                                                          null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "",    null: false
    t.string   "password_digest"
    t.string   "username"
    t.boolean  "admin_flag",         default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "encrypted_password", default: "",    null: false
    t.integer  "sign_in_count",      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "bus_route_informations", "bus_operation_companies"
  add_foreign_key "bus_stop_photos", "bus_stops"
  add_foreign_key "bus_stop_photos", "users"
  add_foreign_key "bus_stops", "prefectures"
end
