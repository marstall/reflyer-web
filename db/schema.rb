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

ActiveRecord::Schema.define(version: 20171206210101) do

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     default: 0, null: false
    t.integer  "match_id",   limit: 4,     default: 0, null: false
    t.text     "text",       limit: 65535,             null: false
    t.datetime "created_at",                           null: false
    t.integer  "num_votes",  limit: 4
    t.integer  "total_vote", limit: 4
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id",           limit: 4,   default: 0, null: false
    t.integer  "recommendation_id", limit: 4,   default: 0, null: false
    t.string   "email_address",     limit: 255
    t.datetime "created_at",                                null: false
    t.integer  "contact_user_id",   limit: 4
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at"
    t.string   "action",      limit: 8
    t.string   "object_type", limit: 16
    t.integer  "object_id",   limit: 4
    t.integer  "user_id",     limit: 4
    t.string   "info",        limit: 255
  end

  add_index "events", ["object_id", "object_type"], name: "object_id_2", using: :btree
  add_index "events", ["object_id"], name: "object_id", using: :btree

  create_table "facebook_settings", force: :cascade do |t|
    t.string   "facebook_userid",     limit: 128
    t.string   "friend_id",           limit: 128
    t.string   "name",                limit: 128
    t.string   "metro_code",          limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "music",               limit: 65535
    t.string   "zipcode",             limit: 5
    t.text     "friends_music",       limit: 65535
    t.string   "has_added_app",       limit: 4
    t.text     "tv",                  limit: 65535
    t.string   "birthday",            limit: 32
    t.string   "city",                limit: 128
    t.string   "state",               limit: 8
    t.string   "country",             limit: 8
    t.string   "zip",                 limit: 8
    t.string   "visited_canvas",      limit: 5
    t.string   "tourfilter_username", limit: 128
  end

  add_index "facebook_settings", ["facebook_userid"], name: "facebook_userid", using: :btree

  create_table "flyers", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",             limit: 4
    t.string   "image_url",           limit: 255
    t.string   "flagged",             limit: 255
    t.string   "status",              limit: 8
    t.string   "image_file_name",     limit: 255
    t.string   "image_content_type",  limit: 255
    t.integer  "image_file_size",     limit: 4
    t.datetime "image_updated_at"
    t.string   "image_fingerprint",   limit: 64
    t.text     "body",                limit: 65535
    t.string   "venue_name",          limit: 255
    t.string   "category",            limit: 255
    t.integer  "latlng",              limit: 4
    t.integer  "place_id",            limit: 4
    t.float    "lat",                 limit: 53
    t.float    "lng",                 limit: 53
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "title",               limit: 255
    t.text     "buzz",                limit: 65535
    t.integer  "score",               limit: 4,     default: 0, null: false
    t.string   "date_type",           limit: 255
    t.datetime "last_sent_to_top_at"
  end

  add_index "flyers", ["user_id"], name: "user_id", using: :btree

  create_table "flyers_users", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, default: 0, null: false
    t.integer  "flyer_id",   limit: 4, default: 0, null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "flyers_users", ["flyer_id", "user_id"], name: "flyer_id", using: :btree

  create_table "imported_events_matches", force: :cascade do |t|
    t.integer  "imported_event_id", limit: 4,  default: 0, null: false
    t.integer  "match_id",          limit: 4,  default: 0, null: false
    t.string   "description",       limit: 64
    t.datetime "created_at",                               null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "email_address",         limit: 255
    t.integer  "from_user_id",          limit: 4
    t.integer  "to_user_id",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "to_user_registered_at"
    t.text     "message",               limit: 65535
  end

  add_index "invitations", ["email_address"], name: "email_address", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "term_id",           limit: 4
    t.string   "term_text",         limit: 64
    t.string   "asin",              limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_reference",  limit: 8
    t.string   "detail_page_url",   limit: 255
    t.integer  "sales_rank",        limit: 4
    t.string   "small_image_url",   limit: 255
    t.string   "medium_image_url",  limit: 255
    t.string   "large_image_url",   limit: 255
    t.string   "artist",            limit: 128
    t.string   "binding",           limit: 32
    t.string   "format",            limit: 32
    t.string   "label",             limit: 128
    t.integer  "list_price",        limit: 4
    t.integer  "number_of_discs",   limit: 4
    t.string   "product_group",     limit: 32
    t.string   "publisher",         limit: 32
    t.date     "release_date"
    t.string   "studio",            limit: 32
    t.string   "title",             limit: 255
    t.string   "upc",               limit: 16
    t.integer  "lowest_new_price",  limit: 4
    t.integer  "lowest_used_price", limit: 4
    t.integer  "total_new",         limit: 4
    t.integer  "total_used",        limit: 4
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "term_id",                         limit: 4,     default: 0,        null: false
    t.integer  "page_id",                         limit: 4,     default: 0,        null: false
    t.string   "status",                          limit: 8
    t.integer  "recommendations_count",           limit: 4,     default: 0
    t.string   "time_status",                     limit: 12
    t.integer  "year",                            limit: 4
    t.integer  "month",                           limit: 4
    t.integer  "day",                             limit: 4
    t.datetime "date_for_sorting"
    t.datetime "calculated_date_for_sorting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flag_count",                      limit: 4,     default: 0
    t.integer  "comments_count",                  limit: 4,     default: 0
    t.string   "date_position",                   limit: 6,     default: "before"
    t.integer  "month_position",                  limit: 4
    t.text     "date_block",                      limit: 65535
    t.integer  "replaced_with_imported_event_id", limit: 4
    t.string   "venue_name",                      limit: 255
    t.integer  "venue_id",                        limit: 4
    t.string   "uid",                             limit: 64
    t.integer  "imported_event_id",               limit: 4
    t.string   "source",                          limit: 32
    t.integer  "user_id",                         limit: 4
    t.string   "level",                           limit: 32
    t.integer  "feature_id",                      limit: 4
    t.datetime "onsale_date"
    t.datetime "presale_date"
    t.string   "url",                             limit: 255
  end

  add_index "matches", ["date_for_sorting"], name: "date_for_sorting", using: :btree
  add_index "matches", ["feature_id"], name: "feature_id", using: :btree
  add_index "matches", ["feature_id"], name: "feature_id_2", using: :btree
  add_index "matches", ["status"], name: "status", using: :btree
  add_index "matches", ["term_id", "page_id", "status"], name: "term_id", using: :btree
  add_index "matches", ["term_id", "time_status", "status", "date_for_sorting"], name: "term_id_2", using: :btree
  add_index "matches", ["term_id"], name: "term_id_3", using: :btree
  add_index "matches", ["time_status", "status", "date_for_sorting", "term_id"], name: "time_status_3", using: :btree
  add_index "matches", ["time_status", "status", "date_for_sorting"], name: "time_status_2", using: :btree
  add_index "matches", ["time_status"], name: "time_status", using: :btree

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

  create_table "notes", force: :cascade do |t|
    t.integer  "source_id",  limit: 4
    t.string   "action",     limit: 16
    t.text     "message",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    limit: 4
  end

  create_table "page_views", force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "youser_id",               limit: 4
    t.string   "ip_address",              limit: 16
    t.string   "domain",                  limit: 64
    t.string   "url",                     limit: 255
    t.string   "form_contents",           limit: 255
    t.string   "referer",                 limit: 255
    t.float    "time_to_render",          limit: 24
    t.string   "session_id",              limit: 64
    t.string   "perm_session_id",         limit: 64
    t.string   "user_agent",              limit: 255
    t.string   "referer_domain",          limit: 255
    t.string   "source",                  limit: 0
    t.string   "original_referer_domain", limit: 64
    t.string   "original_referer_path",   limit: 255
  end

  add_index "page_views", ["created_at"], name: "created_at", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "url",                    limit: 255
    t.text     "raw_body",               limit: 16777215
    t.text     "body",                   limit: 16777215
    t.datetime "last_crawled_at",                                     null: false
    t.integer  "place_id",               limit: 4,        default: 0, null: false
    t.string   "meth",                   limit: 6
    t.string   "flags",                  limit: 0
    t.string   "status",                 limit: 6
    t.integer  "year",                   limit: 4
    t.integer  "month",                  limit: 4
    t.integer  "day",                    limit: 4
    t.string   "raw_body_md5",           limit: 16
    t.integer  "num_consecutive_errors", limit: 4
    t.datetime "last_changed_at"
  end

  add_index "pages", ["place_id"], name: "fk_pages_places", using: :btree
  add_index "pages", ["status"], name: "status", using: :btree

  create_table "place_images", force: :cascade do |t|
    t.integer  "place_id",   limit: 4
    t.string   "page_id",    limit: 255
    t.string   "url",        limit: 255
    t.integer  "width",      limit: 4
    t.integer  "height",     limit: 4
    t.string   "alt_text",   limit: 1024
    t.integer  "term_id",    limit: 4
    t.datetime "created_at"
    t.string   "term_text",  limit: 128
  end

  add_index "place_images", ["url"], name: "url", unique: true, using: :btree

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

  create_table "playlists", force: :cascade do |t|
    t.string   "source",     limit: 8
    t.string   "url",        limit: 255
    t.string   "show_id",    limit: 8
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlists", ["show_id"], name: "show_id", using: :btree

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
    t.integer  "success_count",  limit: 4
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     default: 0, null: false
    t.integer  "match_id",   limit: 4,     default: 0, null: false
    t.text     "text",       limit: 65535,             null: false
    t.string   "mp3_url",    limit: 255
    t.datetime "created_at",                           null: false
    t.date     "event_at"
  end

  create_table "recommendees_recommenders", force: :cascade do |t|
    t.integer  "recommendee_id", limit: 4, default: 0, null: false
    t.integer  "recommender_id", limit: 4, default: 0, null: false
    t.datetime "created_at",                           null: false
  end

  create_table "related_terms", force: :cascade do |t|
    t.integer "term_id",           limit: 4
    t.string  "term_text",         limit: 64
    t.integer "related_term_id",   limit: 4
    t.string  "related_term_text", limit: 64
    t.integer "count",             limit: 4
  end

  add_index "related_terms", ["count"], name: "count", using: :btree
  add_index "related_terms", ["id"], name: "term_id", using: :btree
  add_index "related_terms", ["term_id"], name: "term_id_2", using: :btree
  add_index "related_terms", ["term_text"], name: "term_text", using: :btree

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

  create_table "sources", force: :cascade do |t|
    t.string   "name",              limit: 64
    t.string   "description",       limit: 255
    t.string   "status",            limit: 15
    t.string   "genre",             limit: 32
    t.string   "locale",            limit: 32
    t.string   "person1_firstname", limit: 128
    t.string   "person1_lastname",  limit: 128
    t.string   "person1_title",     limit: 128
    t.string   "person1_email",     limit: 128
    t.string   "person1_phone",     limit: 32
    t.string   "url",               limit: 255
    t.string   "blog_url",          limit: 255
    t.string   "rss_url",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_referrals",     limit: 4
    t.integer  "num_signups",       limit: 4
    t.integer  "num_tracks",        limit: 4
    t.string   "category",          limit: 32
    t.integer  "user_id",           limit: 4
    t.integer  "notes_count",       limit: 4,     default: 0
    t.string   "image",             limit: 255
    t.date     "mention_date"
    t.text     "blurb",             limit: 65535
    t.string   "feature",           limit: 8
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

  create_table "term_urls", force: :cascade do |t|
    t.integer  "term_id",        limit: 4
    t.string   "term_text",      limit: 255
    t.string   "url",            limit: 255
    t.datetime "created_at"
    t.integer  "source_page_id", limit: 4
  end

  add_index "term_urls", ["url"], name: "url", unique: true, using: :btree

  create_table "term_words", force: :cascade do |t|
    t.string   "word",       limit: 255
    t.integer  "term_id",    limit: 4,   null: false
    t.datetime "created_at"
  end

  create_table "terms", force: :cascade do |t|
    t.string   "text",                   limit: 255
    t.datetime "created_at"
    t.integer  "num_tracks",             limit: 4
    t.integer  "num_ram_tracks",         limit: 4
    t.integer  "num_mp3_tracks",         limit: 4
    t.string   "source",                 limit: 32
    t.string   "url",                    limit: 255
    t.integer  "num_trackers",           limit: 4,   default: 0
    t.integer  "aggregate_num_trackers", limit: 4,   default: 0
  end

  add_index "terms", ["text"], name: "text", using: :btree
  add_index "terms", ["text"], name: "text_2", unique: true, using: :btree

  create_table "terms_temp", force: :cascade do |t|
    t.string   "text",           limit: 255
    t.datetime "created_at"
    t.integer  "num_tracks",     limit: 4
    t.integer  "num_ram_tracks", limit: 4
    t.integer  "num_mp3_tracks", limit: 4
  end

  add_index "terms_temp", ["text"], name: "text", using: :btree
  add_index "terms_temp", ["text"], name: "text_2", unique: true, using: :btree

  create_table "terms_users", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4, default: 0, null: false
    t.integer  "term_id",    limit: 4, default: 0, null: false
    t.datetime "created_at"
  end

  add_index "terms_users", ["term_id", "user_id"], name: "term_id_2", using: :btree
  add_index "terms_users", ["term_id"], name: "term_id", using: :btree
  add_index "terms_users", ["user_id", "term_id"], name: "user_id_2", using: :btree
  add_index "terms_users", ["user_id"], name: "user_id", using: :btree
  add_index "terms_users", ["user_id"], name: "user_id_3", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.integer "term_id",          limit: 4
    t.string  "band_name",        limit: 255
    t.string  "track_name",       limit: 255
    t.string  "album_name",       limit: 255
    t.string  "url",              limit: 255
    t.string  "file_type",        limit: 3
    t.integer "offset",           limit: 4
    t.integer "playlist_id",      limit: 4
    t.string  "playlist_url",     limit: 255
    t.string  "source_reference", limit: 8
    t.string  "label",            limit: 255
    t.string  "archive_id",       limit: 8
    t.string  "show_id",          limit: 8
    t.integer "year",             limit: 4
    t.text    "description",      limit: 65535
    t.string  "status",           limit: 7
    t.integer "ttl",              limit: 4
    t.string  "filename",         limit: 255
  end

  add_index "tracks", ["band_name"], name: "band_name", using: :btree
  add_index "tracks", ["file_type", "term_id"], name: "file_type", using: :btree
  add_index "tracks", ["file_type", "term_id"], name: "file_type_3", using: :btree
  add_index "tracks", ["file_type"], name: "file_type_2", using: :btree
  add_index "tracks", ["file_type"], name: "file_type_4", using: :btree
  add_index "tracks", ["term_id", "file_type"], name: "term_id_2", using: :btree
  add_index "tracks", ["term_id", "file_type"], name: "term_id_4", using: :btree
  add_index "tracks", ["term_id"], name: "term_id", using: :btree
  add_index "tracks", ["term_id"], name: "term_id_3", using: :btree
  add_index "tracks", ["track_name"], name: "track_name", using: :btree

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

  create_table "user_ticket_offers", force: :cascade do |t|
    t.string   "uid",               limit: 64
    t.integer  "user_id",           limit: 4
    t.integer  "match_id",          limit: 4
    t.float    "price",             limit: 24
    t.integer  "quantity",          limit: 4
    t.string   "section",           limit: 32
    t.string   "row",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "subject",           limit: 65535
    t.text     "body",              limit: 65535
    t.string   "match_description", limit: 255
    t.integer  "flag_count",        limit: 4,     default: 0
  end

  add_index "user_ticket_offers", ["match_id"], name: "match_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "metro_code",                     limit: 255
    t.string   "expo_push_token",                limit: 255
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "device_id",                      limit: 255
    t.string   "notifications_permission_state", limit: 255
    t.string   "email",                          limit: 255, default: "", null: false
    t.string   "encrypted_password",             limit: 255, default: "", null: false
    t.boolean  "admin"
  end

end
