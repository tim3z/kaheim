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

ActiveRecord::Schema.define(version: 2019_05_25_104015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "resource_id", limit: 255, null: false
    t.string "resource_type", limit: 255, null: false
    t.integer "author_id"
    t.string "author_type", limit: 255
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "namespace", limit: 255
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "answers", force: :cascade do |t|
    t.string "mail", limit: 255
    t.text "message"
    t.integer "item_id"
    t.string "item_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_id", "item_type"], name: "index_answers_on_item_id_and_item_type"
  end

  create_table "history_items", force: :cascade do |t|
    t.integer "offers_count"
    t.integer "requests_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_reactivators", force: :cascade do |t|
    t.string "token", limit: 255
    t.integer "item_id"
    t.string "item_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_id", "item_type"], name: "index_item_reactivators_on_item_id_and_item_type"
    t.index ["token"], name: "index_item_reactivators_on_token", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.string "title", limit: 255
    t.text "description"
    t.date "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "rent"
    t.integer "size"
    t.integer "gender", default: 0
    t.date "from_date"
    t.string "district", limit: 255
    t.string "street", limit: 255
    t.string "zip_code", limit: 255
    t.boolean "is_public", default: true
    t.string "owner_name", null: false
    t.string "email", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "email_confirmed_at"
  end

  create_table "requests", force: :cascade do |t|
    t.string "title", limit: 255
    t.text "description"
    t.date "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "from_date"
    t.integer "gender", default: 0
    t.boolean "is_public", default: true
    t.string "owner_name", null: false
    t.string "email", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "email_confirmed_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email", limit: 255
    t.boolean "offers", default: false
    t.boolean "requests", default: false
    t.string "confirmation_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "unsubscribe_token", limit: 255
    t.index ["confirmation_token"], name: "index_subscriptions_on_confirmation_token"
    t.index ["email"], name: "index_subscriptions_on_email"
    t.index ["offers"], name: "index_subscriptions_on_offers"
    t.index ["requests"], name: "index_subscriptions_on_requests"
    t.index ["unsubscribe_token"], name: "index_subscriptions_on_unsubscribe_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false, null: false
    t.string "name", limit: 255
    t.boolean "unlocked", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
