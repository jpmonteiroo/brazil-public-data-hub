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

ActiveRecord::Schema[8.1].define(version: 2026_04_18_154321) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "data_sources", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "base_url", null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_data_sources_on_slug", unique: true
  end

  create_table "indicator_snapshots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fetched_at", null: false
    t.bigint "indicator_id", null: false
    t.string "place_code"
    t.string "place_name"
    t.string "place_type"
    t.jsonb "raw_payload", default: {}, null: false
    t.date "reference_date", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 15, scale: 4
    t.index ["indicator_id", "reference_date", "place_code"], name: "idx_indicator_snapshots_uniqueness", unique: true
    t.index ["indicator_id"], name: "index_indicator_snapshots_on_indicator_id"
  end

  create_table "indicators", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.bigint "data_source_id", null: false
    t.text "description"
    t.jsonb "metadata", default: {}, null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "source_code"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_indicators_on_category"
    t.index ["data_source_id"], name: "index_indicators_on_data_source_id"
    t.index ["slug"], name: "index_indicators_on_slug", unique: true
  end

  create_table "sync_runs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "data_source_id", null: false
    t.text "error_message"
    t.datetime "finished_at"
    t.integer "items_count", default: 0, null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "started_at"
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["data_source_id"], name: "index_sync_runs_on_data_source_id"
    t.index ["status"], name: "index_sync_runs_on_status"
  end

  add_foreign_key "indicator_snapshots", "indicators"
  add_foreign_key "indicators", "data_sources"
  add_foreign_key "sync_runs", "data_sources"
end
