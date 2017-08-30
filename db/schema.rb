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

ActiveRecord::Schema.define(version: 20170830161401) do

  create_table "flyers", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",            limit: 4
    t.string   "image_url",          limit: 255
    t.string   "flagged",            limit: 255
    t.string   "status",             limit: 8
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "image_fingerprint",  limit: 64
    t.text     "body",               limit: 65535
    t.string   "venue_name",         limit: 255
    t.string   "category",           limit: 255
    t.integer  "latlng",             limit: 4
    t.integer  "place_id",           limit: 4
    t.float    "lat",                limit: 53
    t.float    "lng",                limit: 53
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "title",              limit: 255
    t.text     "buzz",               limit: 65535
    t.integer  "score",              limit: 4,     default: 0, null: false
    t.string   "date_type",          limit: 255
  end

  add_index "flyers", ["user_id"], name: "user_id", using: :btree

  create_table "flyers_users", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, default: 0, null: false
    t.integer  "flyer_id",   limit: 4, default: 0, null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "flyers_users", ["flyer_id", "user_id"], name: "flyer_id", using: :btree

  create_table "metros", force: :cascade do |t|
    t.string  "name",         limit: 128, default: "",    null: false
    t.string  "code",         limit: 128
    t.integer "num_places",   limit: 4
    t.string  "status",       limit: 0
    t.string  "state",        limit: 4
    t.string  "zipcode",      limit: 5
    t.float   "lng",          limit: 53
    t.float   "lat",          limit: 53
    t.string  "country_code", limit: 2
    t.integer "num_matches",  limit: 4
    t.boolean "curated",                  default: false
    t.integer "latlng",       limit: 4,                   null: false
  end

  add_index "metros", ["code"], name: "code", unique: true, using: :btree
  add_index "metros", ["latlng"], name: "latlng", length: {"latlng"=>32}, type: :spatial

  create_table "places", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "source",            limit: 255
    t.string   "source_id",         limit: 255
    t.integer  "latlng",            limit: 4
    t.string   "city",              limit: 255
    t.string   "state",             limit: 255
    t.string   "country",           limit: 255
    t.string   "formatted_address", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat",               limit: 53
    t.float    "lng",               limit: 53
  end

  create_table "push_notifications", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "body",           limit: 65535
    t.datetime "pushed_at"
    t.string   "recipient_type", limit: 255
    t.integer  "place_id",       limit: 4
    t.string   "category",       limit: 255
    t.integer  "user_id",        limit: 4
    t.string   "response_code",  limit: 255
    t.text     "response_json",  limit: 65535
    t.integer  "error_count",    limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.string   "resource",        limit: 255
    t.string   "url",             limit: 255
    t.string   "response_string", limit: 255
    t.integer  "http_code",       limit: 4
    t.string   "headers",         limit: 255
    t.integer  "bytes",           limit: 4
    t.integer  "tts",             limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",     limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.integer  "flyer_id",   limit: 4, default: 0, null: false
  end

  add_index "taggings", ["flyer_id"], name: "flyer_id", using: :btree
  add_index "taggings", ["tag_id"], name: "tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.string   "text",       limit: 255, default: "", null: false
  end

  add_index "tags", ["text"], name: "text", using: :btree

  create_table "user_actions", force: :cascade do |t|
    t.string   "action_type",    limit: 255
    t.string   "action_subtype", limit: 255
    t.integer  "flyer_id",       limit: 4
    t.string   "description",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id",        limit: 4
    t.string   "data",           limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "metro_code",                     limit: 255
    t.string   "expo_push_token",                limit: 255
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "device_id",                      limit: 255
    t.string   "notifications_permission_state", limit: 255
  end

end
