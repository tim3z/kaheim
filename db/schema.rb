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

ActiveRecord::Schema.define(version: 20140910162201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "answers", force: true do |t|
    t.string   "mail"
    t.text     "message"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["item_id", "item_type"], name: "index_answers_on_item_id_and_item_type", using: :btree

  create_table "item_reactivators", force: true do |t|
    t.string   "token"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_reactivators", ["item_id", "item_type"], name: "index_item_reactivators_on_item_id_and_item_type", using: :btree
  add_index "item_reactivators", ["token"], name: "index_item_reactivators_on_token", unique: true, using: :btree

  create_table "offers", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     default: 0, null: false
    t.integer  "rent"
    t.integer  "size"
    t.integer  "gender",      default: 0
    t.date     "from_date"
    t.string   "district"
    t.string   "street"
    t.string   "zip_code"
  end

  create_table "requests", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     default: 0, null: false
    t.date     "from_date"
    t.integer  "gender",      default: 0
  end

  create_table "subscriptions", force: true do |t|
    t.string   "email"
    t.boolean  "offers",             default: false
    t.boolean  "requests",           default: false
    t.string   "confirmation_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
    t.string   "name"
    t.boolean  "unlocked",               default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
