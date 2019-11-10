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

ActiveRecord::Schema.define(version: 2019_11_05_194701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aspects", force: :cascade do |t|
    t.datetime "begin_void"
    t.datetime "end_void"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "degree"
    t.string "formatted_degree"
    t.string "planet"
    t.string "formatted_planet"
  end

  create_table "void_scrapers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voids", force: :cascade do |t|
    t.datetime "begin"
    t.datetime "end"
    t.string "begin_sign"
    t.string "end_sign"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "aspect_id"
    t.index ["aspect_id"], name: "index_voids_on_aspect_id"
  end

  add_foreign_key "voids", "aspects"
end
