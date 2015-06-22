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

ActiveRecord::Schema.define(version: 20150603180511) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.string   "game_type"
  end

  create_table "challenges", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_game_id"
    t.integer  "receiver_game_id"
    t.string   "sender_status"
    t.string   "receiver_status"
  end

  add_index "challenges", ["receiver_game_id"], name: "index_challenges_on_receiver_game_id", using: :btree
  add_index "challenges", ["receiver_id"], name: "index_challenges_on_receiver_id", using: :btree
  add_index "challenges", ["sender_game_id"], name: "index_challenges_on_sender_game_id", using: :btree
  add_index "challenges", ["sender_id"], name: "index_challenges_on_sender_id", using: :btree

  create_table "multi_player_games", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "locale"
    t.integer  "duration"
    t.integer  "steps"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_finished"
  end

  create_table "single_player_games", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_finished"
    t.integer  "duration"
    t.integer  "steps"
    t.string   "locale"
  end

  add_index "single_player_games", ["user_id"], name: "index_single_player_games_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pseudo"
    t.string   "authentication_token"
    t.string   "password_reset_token"
    t.datetime "password_expires_after"
    t.datetime "signed_up_on"
    t.datetime "last_signed_in_on"
    t.string   "preferred_locale"
  end

end
