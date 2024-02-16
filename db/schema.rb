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

ActiveRecord::Schema.define(:version => 20240215203146) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "product_id"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_categories", :force => true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price"
    t.boolean  "first_purchase_email_sent", :default => false
    t.integer  "creator_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "purchases", :force => true do |t|
    t.integer  "product_id"
    t.integer  "customer_id"
    t.integer  "quantity"
    t.decimal  "total_price"
    t.datetime "purchase_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :null => false
    t.text     "password_digest",                      :null => false
    t.string   "role",            :default => "buyer", :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
