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

ActiveRecord::Schema.define(:version => 20150418181019) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "game_id"
    t.string   "game_type"
  end

  create_table "challenges", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "locale"
    t.string   "status"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "sender_game_id"
    t.integer  "receiver_game_id"
  end

  add_index "challenges", ["receiver_game_id"], :name => "index_challenges_on_receiver_game_id"
  add_index "challenges", ["receiver_id"], :name => "index_challenges_on_receiver_id"
  add_index "challenges", ["sender_game_id"], :name => "index_challenges_on_sender_game_id"
  add_index "challenges", ["sender_id"], :name => "index_challenges_on_sender_id"

  create_table "multi_player_games", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "locale"
    t.datetime "duration"
    t.integer  "steps"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "single_player_games", :force => true do |t|
    t.string    "from"
    t.string    "to"
    t.integer   "user_id"
    t.datetime  "created_at", :null => false
    t.datetime  "updated_at", :null => false
    t.boolean   "is_victory"
    t.timestamp "duration"
    t.integer   "steps"
    t.string    "locale"
  end

  add_index "single_player_games", ["user_id"], :name => "index_single_player_games_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "pseudo"
    t.string   "authentication_token"
    t.string   "password_reset_token"
    t.datetime "password_expires_after"
  end

end
