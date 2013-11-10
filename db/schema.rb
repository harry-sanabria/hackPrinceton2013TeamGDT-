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

ActiveRecord::Schema.define(version: 20131110025413) do

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "purchase_id"
    t.decimal  "price"
    t.text     "description"
  end

  create_table "purchases", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "deadline"
    t.decimal  "min_price"
    t.decimal  "current_total_price"
    t.integer  "user_id"
    t.string   "group"
    t.integer  "state"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_token"
    t.string   "provider"
    t.string   "uid"
    t.datetime "oauth_expires_at"
    t.string   "image_url"
  end

  create_table "venmos", force: true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "venmo_id"
    t.string   "refresh_code"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
