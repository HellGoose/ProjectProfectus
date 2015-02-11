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

ActiveRecord::Schema.define(version: 20150210142834) do

  create_table "iterations", force: :cascade do |t|
    t.date     "startDate"
    t.date     "endDate"
    t.float    "totalAmount", limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "projects", force: :cascade do |t|
    t.text     "content",         limit: 65535
    t.text     "tags",            limit: 65535
    t.boolean  "flagged",         limit: 1
    t.integer  "voteCount",       limit: 4
    t.integer  "finalVoteCount",  limit: 4
    t.string   "logoLink",        limit: 255
    t.boolean  "isGettingFunded", limit: 1
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "oauth_token",            limit: 255
    t.datetime "oauth_token_expires_at"
    t.string   "username",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "address",                limit: 255
    t.string   "phone",                  limit: 255
    t.datetime "bannedUntil"
    t.float    "subscriptionAmount",     limit: 24
    t.integer  "points",                 limit: 4
    t.integer  "role",                   limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

end
