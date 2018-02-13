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

ActiveRecord::Schema.define(:version => 20150904110438) do

  create_table "accounts", :force => true do |t|
    t.string   "first_name", :limit => nil, :null => false
    t.string   "last_name",  :limit => nil
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "ar_internal_metadata", :primary_key => "key", :force => true do |t|
    t.string   "value",      :limit => nil
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "ar_internal_metadata", ["key"], :name => "sqlite_autoindex_ar_internal_metadata_1", :unique => true

  create_table "logins", :force => true do |t|
    t.string   "identification",          :limit => nil, :null => false
    t.string   "password_digest",         :limit => nil
    t.string   "oauth2_token",            :limit => nil, :null => false
    t.string   "uid",                     :limit => nil
    t.string   "single_use_oauth2_token", :limit => nil
    t.integer  "user_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider",                :limit => nil
  end

  add_index "logins", ["user_id"], :name => "index_logins_on_user_id"

end
