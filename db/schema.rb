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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120228212422) do

  create_table "tweets", :force => true do |t|
    t.string   "twitter_uid"
    t.text     "text"
    t.integer  "twitter_user_id"
    t.datetime "timestamp"
    t.boolean  "is_atreply"
    t.integer  "fav_count"
    t.float    "fav_weight"
    t.float    "favs_per_follower"
    t.string   "hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "twitter_uid"
    t.string   "twitter_username"
    t.string   "avatar_url"
    t.integer  "crawl_interval"
    t.integer  "latest_crawl_fav_count"
    t.datetime "last_refreshed_from_twitter"
    t.integer  "followers_count"
    t.integer  "favorites_count"
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.datetime "created_at"
    t.boolean  "ready_to_be_crawled"
    t.boolean  "crawling_enabled"
    t.datetime "latest_crawl_time"
    t.datetime "next_crawl_time"
    t.datetime "updated_at"
  end

end
