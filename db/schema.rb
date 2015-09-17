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

ActiveRecord::Schema.define(version: 20150916115304) do

  create_table "badges", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "imageUrl",    limit: 255
    t.integer  "points",      limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "campaign_votes", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "campaign_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "step",        limit: 4
    t.integer  "voteType",    limit: 4
  end

  add_index "campaign_votes", ["campaign_id"], name: "index_campaign_votes_on_campaign_id", using: :btree
  add_index "campaign_votes", ["user_id"], name: "index_campaign_votes_on_user_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.string   "link",                 limit: 255
    t.string   "description",          limit: 255
    t.integer  "user_id",              limit: 4
    t.integer  "category_id",          limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image",                limit: 255
    t.integer  "roundScore",           limit: 4
    t.integer  "globalScore",          limit: 4
    t.integer  "timesShownInVoting",   limit: 4
    t.integer  "nominator_id",         limit: 4
    t.text     "content",              limit: 65535
    t.integer  "pledged",              limit: 4
    t.integer  "goal",                 limit: 4
    t.string   "author",               limit: 255
    t.integer  "backers",              limit: 4
    t.date     "end_time"
    t.boolean  "nominated",            limit: 1
    t.boolean  "votable",              limit: 1
    t.integer  "crowdfunding_site_id", limit: 4
    t.string   "status",               limit: 255
  end

  add_index "campaigns", ["category_id"], name: "index_campaigns_on_category_id", using: :btree
  add_index "campaigns", ["crowdfunding_site_id"], name: "index_campaigns_on_crowdfunding_site_id", using: :btree
  add_index "campaigns", ["nominator_id"], name: "fk_rails_d8d6273771", using: :btree
  add_index "campaigns", ["user_id"], name: "index_campaigns_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "crowdfunding_sites", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "logo",       limit: 255
    t.string   "link",       limit: 255
    t.string   "domain",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.boolean  "sticky",     limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "points_histories", force: :cascade do |t|
    t.integer  "points_received", limit: 4
    t.string   "description",     limit: 255
    t.boolean  "seen",            limit: 1
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id",         limit: 4
  end

  add_index "points_histories", ["user_id"], name: "index_points_histories_on_user_id", using: :btree

  create_table "post_comments", id: false, force: :cascade do |t|
    t.integer "comment_id", limit: 4
    t.integer "post_id",    limit: 4
  end

  add_index "post_comments", ["comment_id"], name: "index_post_comments_on_comment_id", using: :btree
  add_index "post_comments", ["post_id"], name: "index_post_comments_on_post_id", using: :btree

  create_table "post_votes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "post_id",    limit: 4
    t.boolean  "isDownvote", limit: 1
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "post_votes", ["post_id"], name: "index_post_votes_on_post_id", using: :btree
  add_index "post_votes", ["user_id"], name: "index_post_votes_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "content",     limit: 65535
    t.boolean  "isComment",   limit: 1
    t.integer  "voteCount",   limit: 4
    t.integer  "campaign_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "posts", ["campaign_id"], name: "index_posts_on_campaign_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "round_winner_campaigns", force: :cascade do |t|
    t.integer  "roundWon",    limit: 4
    t.integer  "placing",     limit: 4
    t.integer  "campaign_id", limit: 4
    t.integer  "round_id",    limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "round_winner_users", force: :cascade do |t|
    t.integer  "roundWon",   limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "round_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "duration",            limit: 4
    t.boolean  "forceNewRound",       limit: 1
    t.float    "decayRate",           limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "currentRound",        limit: 4
    t.datetime "endTime"
    t.integer  "maxAdditionsPerUser", limit: 4
  end

  create_table "stat_dumps", force: :cascade do |t|
    t.integer  "roundNumber",             limit: 4
    t.text     "details",                 limit: 65535
    t.integer  "numberOfNominations",     limit: 4
    t.integer  "numberOfNominationsSeen", limit: 4
    t.integer  "numberOfVotes",           limit: 4
    t.integer  "numberOfFinalVotes",      limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "user_badges", force: :cascade do |t|
    t.integer  "user_id",       limit: 4, null: false
    t.integer  "badge_id",      limit: 4, null: false
    t.integer  "timesAchieved", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_badges", ["badge_id"], name: "index_user_badges_on_badge_id", using: :btree
  add_index "user_badges", ["user_id"], name: "index_user_badges_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "image",                  limit: 255
    t.string   "location",               limit: 255
    t.string   "address",                limit: 255
    t.string   "phone",                  limit: 255
    t.integer  "points",                 limit: 4
    t.integer  "level",                  limit: 4
    t.integer  "role",                   limit: 4
    t.datetime "bannedUntil"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "oauth_token",            limit: 255
    t.datetime "oauth_token_expires_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "isOnStep",               limit: 4
    t.boolean  "hasLoggedInThisRound",   limit: 1
    t.integer  "additionsThisRound",     limit: 4
  end

  add_foreign_key "campaigns", "users", column: "nominator_id"
  add_foreign_key "points_histories", "users"
end
