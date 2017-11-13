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

ActiveRecord::Schema.define(version: 20171115193342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "match_conversation_instances", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.integer  "target_id",                             null: false
    t.integer  "match_conversation_id",                 null: false
    t.datetime "last_logout",                           null: false
    t.string   "title"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "online",                default: false
    t.index ["match_conversation_id"], name: "index_match_conversation_instances_on_match_conversation_id", using: :btree
    t.index ["target_id"], name: "index_match_conversation_instances_on_target_id", using: :btree
    t.index ["user_id", "match_conversation_id"], name: "user_conversation_instance_index", unique: true, using: :btree
    t.index ["user_id"], name: "index_match_conversation_instances_on_user_id", using: :btree
  end

  create_table "match_conversations", force: :cascade do |t|
    t.integer  "topic_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_match_conversations_on_topic_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "match_conversation_instance_id"
    t.integer  "user_id"
    t.string   "content"
    t.boolean  "read",                           default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["match_conversation_instance_id"], name: "index_messages_on_match_conversation_instance_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "targets", force: :cascade do |t|
    t.string    "title",                                                                                  null: false
    t.float     "lat",                                                                                    null: false
    t.float     "lng",                                                                                    null: false
    t.float     "radius",                                                                                 null: false
    t.integer   "topic_id",                                                                               null: false
    t.integer   "user_id",                                                                                null: false
    t.datetime  "created_at",                                                                             null: false
    t.datetime  "updated_at",                                                                             null: false
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"st_point", :geographic=>true},                 null: false
    t.boolean   "matched",                                                                default: false
    t.index ["lonlat"], name: "index_targets_on_lonlat", using: :gist
    t.index ["matched"], name: "index_targets_on_matched", using: :btree
    t.index ["topic_id"], name: "index_targets_on_topic_id", using: :btree
    t.index ["user_id"], name: "index_targets_on_user_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "label",      null: false
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "username",               default: ""
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.json     "tokens"
    t.integer  "gender"
    t.string   "avatar"
    t.string   "push_token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
