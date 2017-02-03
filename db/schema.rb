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

ActiveRecord::Schema.define(version: 0) do

  create_table "flyers", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image_url"
    t.string   "flagged"
    t.string   "status",             limit: 8
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "category",           limit: 32
    t.string   "image_fingerprint",  limit: 64
    t.text     "body",               limit: 65535
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "flyers_users", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",    default: 0,                          null: false
    t.integer  "flyer_id",   default: 0,                          null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at"
    t.index ["flyer_id", "user_id"], name: "flyer_id", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "tag_id",     default: 0,                          null: false
    t.datetime "created_at"
    t.integer  "flyer_id",   default: 0,                          null: false
    t.index ["flyer_id"], name: "flyer_id", using: :btree
    t.index ["tag_id"], name: "tag_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.string   "text",       default: "",                         null: false
    t.index ["text"], name: "text", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email_address"
    t.string   "password"
    t.datetime "registered_on"
    t.datetime "last_logged_in_on"
    t.string   "privs",             limit: 58
    t.datetime "last_visited_on"
    t.string   "last_user_agent"
    t.string   "referer_domain",    limit: 128
    t.string   "referer_path"
    t.index ["last_visited_on"], name: "last_visited_on", using: :btree
  end

end
