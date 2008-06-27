# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "albums", :force => true do |t|
    t.string "name", :limit => 128
  end

  add_index "albums", ["name"], :name => "index_albums_on_name"

  create_table "albums_tags", :id => false, :force => true do |t|
    t.integer "album_id", :limit => 11
    t.integer "tag_id",   :limit => 11
  end

  add_index "albums_tags", ["album_id"], :name => "index_albums_tags_on_album_id"
  add_index "albums_tags", ["tag_id"], :name => "index_albums_tags_on_tag_id"

  create_table "authors", :force => true do |t|
    t.string   "name",               :limit => 64
    t.string   "url",                :limit => 256
    t.datetime "created_at"
    t.string   "salt",               :limit => 512
    t.string   "encrypted_password", :limit => 512
  end

  add_index "authors", ["name"], :name => "index_authors_on_name"

  create_table "authors_permissions", :id => false, :force => true do |t|
    t.integer "author_id",     :limit => 11
    t.integer "permission_id", :limit => 11
  end

  add_index "authors_permissions", ["author_id"], :name => "index_authors_permissions_on_author_id"
  add_index "authors_permissions", ["permission_id"], :name => "index_authors_permissions_on_permission_id"

  create_table "comments", :force => true do |t|
    t.string   "user",       :limit => 32
    t.string   "url",        :limit => 256
    t.datetime "created_at"
    t.integer  "author_id",  :limit => 11
    t.integer  "page_id",    :limit => 11
    t.text     "comment"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["page_id"], :name => "index_comments_on_page_id"

  create_table "invitations", :force => true do |t|
    t.string "code", :limit => 32
  end

  add_index "invitations", ["code"], :name => "index_invitations_on_code"

  create_table "pages", :force => true do |t|
    t.string   "name",        :limit => 64
    t.string   "department",  :limit => 128
    t.boolean  "published",                  :default => false
    t.datetime "created_at"
    t.integer  "author_id",   :limit => 11
    t.integer  "nid",         :limit => 11
    t.text     "description"
  end

  add_index "pages", ["name"], :name => "index_pages_on_name"
  add_index "pages", ["published"], :name => "index_pages_on_published"
  add_index "pages", ["author_id"], :name => "index_pages_on_author_id"
  add_index "pages", ["nid"], :name => "index_pages_on_nid"

  create_table "pages_tags", :id => false, :force => true do |t|
    t.integer "page_id", :limit => 11
    t.integer "tag_id",  :limit => 11
  end

  add_index "pages_tags", ["page_id"], :name => "index_pages_tags_on_page_id"
  add_index "pages_tags", ["tag_id"], :name => "index_pages_tags_on_tag_id"

  create_table "permissions", :force => true do |t|
    t.string "name", :limit => 32
  end

  add_index "permissions", ["name"], :name => "index_permissions_on_name"

  create_table "photo_tags", :force => true do |t|
    t.integer "x",        :limit => 11
    t.integer "y",        :limit => 11
    t.integer "photo_id", :limit => 11
    t.integer "tag_id",   :limit => 11
  end

  add_index "photo_tags", ["photo_id"], :name => "index_photo_tags_on_photo_id"
  add_index "photo_tags", ["tag_id"], :name => "index_photo_tags_on_tag_id"

  create_table "photos", :force => true do |t|
    t.integer "author_id",    :limit => 11
    t.integer "width",        :limit => 11
    t.integer "height",       :limit => 11
    t.integer "album_id",     :limit => 11
    t.string  "filename"
    t.string  "content_type"
  end

  add_index "photos", ["author_id"], :name => "index_photos_on_author_id"
  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.string "name", :limit => 64
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "wiki_words", :force => true do |t|
    t.integer "source_id",      :limit => 11
    t.integer "destination_id", :limit => 11
  end

  add_index "wiki_words", ["source_id"], :name => "index_wiki_words_on_source_id"
  add_index "wiki_words", ["destination_id"], :name => "index_wiki_words_on_destination_id"

end
