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

ActiveRecord::Schema.define(:version => 20111108072743) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_producer", :default => false
  end

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.integer  "account_id"
    t.string   "encrypted_secret_key"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mongo_url"
    t.string   "mongo_host"
    t.integer  "mongo_port"
  end

  create_table "contracts", :force => true do |t|
    t.integer  "app_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "developers", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.boolean  "has_signed_nda"
    t.integer  "beta_access",                           :default => 0
  end

  add_index "developers", ["authentication_token"], :name => "index_developers_on_authentication_token", :unique => true
  add_index "developers", ["confirmation_token"], :name => "index_developers_on_confirmation_token", :unique => true
  add_index "developers", ["email"], :name => "index_developers_on_email", :unique => true
  add_index "developers", ["invitation_token"], :name => "index_developers_on_invitation_token"
  add_index "developers", ["invited_by_id"], :name => "index_developers_on_invited_by_id"
  add_index "developers", ["reset_password_token"], :name => "index_developers_on_reset_password_token", :unique => true

  create_table "documentation_pages", :force => true do |t|
    t.string   "title"
    t.text     "markdown"
    t.string   "cached_slug"
    t.boolean  "recommended"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "documentation_section_id"
    t.integer  "position"
    t.boolean  "live"
  end

  create_table "documentation_sections", :force => true do |t|
    t.string   "title"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.string   "from"
    t.string   "cc"
    t.string   "bcc"
    t.string   "subject"
    t.string   "content_type"
    t.text     "body"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invite_requests", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "why"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "developer_id"
    t.string   "invite_code"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "developer_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_connections", :force => true do |t|
    t.integer  "app_id"
    t.integer  "service_id"
    t.string   "client_key"
    t.string   "encrypted_client_secret"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "connected"
  end

  create_table "service_documentation_pages", :force => true do |t|
    t.string   "title"
    t.text     "markdown"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.string   "base_url"
    t.integer  "base_port"
    t.integer  "beta_level",  :default => 100
    t.string   "service_key"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

end
