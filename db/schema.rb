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

ActiveRecord::Schema.define(version: 20150407111432) do

  create_table "badges", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "imageUrl",    limit: 255
    t.integer  "points",      limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "flaggedProjects", id: false, force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "project_id", limit: 4
  end

  add_index "flaggedProjects", ["project_id"], name: "index_flaggedProjects_on_project_id", using: :btree
  add_index "flaggedProjects", ["user_id"], name: "index_flaggedProjects_on_user_id", using: :btree

  create_table "forums", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "main_pots", force: :cascade do |t|
    t.float    "amount",     limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.boolean  "sticky",     limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "post_comments", id: false, force: :cascade do |t|
    t.integer "id",         limit: 4, null: false
    t.integer "comment_id", limit: 4
    t.integer "post_id",    limit: 4
  end

  add_index "post_comments", ["comment_id"], name: "index_post_comments_on_comment_id", using: :btree
  add_index "post_comments", ["id"], name: "index_post_comments_on_id", using: :btree
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
    t.text     "content",    limit: 65535
    t.integer  "topic_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "isComment",  limit: 1
    t.integer  "voteCount",  limit: 4
  end

  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "project_donations", force: :cascade do |t|
    t.float    "amount",     limit: 24
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "project_donations", ["project_id"], name: "index_porject_donations_on_project_id", using: :btree
  add_index "project_donations", ["user_id"], name: "index_porject_donations_on_user_id", using: :btree

  create_table "project_flags", id: false, force: :cascade do |t|
    t.integer "project_id", limit: 4, null: false
    t.integer "user_id",    limit: 4, null: false
    t.integer "id",         limit: 4
  end

  add_index "project_flags", ["id"], name: "index_project_flags_on_id", using: :btree

  create_table "project_votes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "project_votes", ["project_id"], name: "index_project_votes_on_project_id", using: :btree
  add_index "project_votes", ["user_id"], name: "index_project_votes_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.text     "content",        limit: 65535
    t.integer  "voteCount",      limit: 4
    t.string   "logoLink",       limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title",          limit: 255
    t.text     "description",    limit: 65535
    t.integer  "user_id",        limit: 4
    t.integer  "forum_id",       limit: 4
    t.integer  "category_id",    limit: 4
    t.float    "donationAmount", limit: 24
    t.integer  "flagCount",      limit: 4
    t.integer  "badgeCount",     limit: 4
    t.integer  "flagged",        limit: 4
  end

  add_index "projects", ["category_id"], name: "index_projects_on_category_id", using: :btree
  add_index "projects", ["forum_id"], name: "index_projects_on_forum_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "topic_votes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "topic_id",   limit: 4
    t.boolean  "isDownvote", limit: 1
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "topic_votes", ["topic_id"], name: "index_topic_votes_on_topic_id", using: :btree
  add_index "topic_votes", ["user_id"], name: "index_topic_votes_on_user_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "forum_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "content",    limit: 65535
    t.string   "image",      limit: 255
    t.integer  "voteCount",  limit: 4
  end

  add_index "topics", ["forum_id"], name: "index_topics_on_forum_id", using: :btree
  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

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
    t.string   "image",                  limit: 255
    t.string   "location",               limit: 255
    t.float    "money",                  limit: 24
    t.integer  "badgeCount",             limit: 4
    t.integer  "level",                  limit: 4
  end

end
