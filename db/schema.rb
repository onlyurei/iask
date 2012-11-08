# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "courses", :force => true do |t|
    t.string   "official_id", :default => "", :null => false
    t.string   "name",        :default => "", :null => false
    t.text     "description", :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses_users", :id => false, :force => true do |t|
    t.integer "course_id", :default => 0, :null => false
    t.integer "user_id",   :default => 0, :null => false
  end

  add_index "courses_users", ["course_id", "user_id"], :name => "index_courses_users_on_course_id_and_user_id"
  add_index "courses_users", ["course_id"], :name => "index_courses_users_on_course_id"
  add_index "courses_users", ["user_id"], :name => "index_courses_users_on_user_id"

  create_table "entries", :force => true do |t|
    t.integer  "course_id",        :default => 0,  :null => false
    t.integer  "user_id",          :default => 0,  :null => false
    t.string   "question",         :default => "", :null => false
    t.text     "answer",           :null => false
    t.text     "notes"
    t.string   "user_official_id", :default => "", :null => false
    t.string   "user_last_name",   :default => "", :null => false
    t.string   "user_first_name",  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", :force => true do |t|
    t.string   "value",      :limit => 100, :default => "", :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queries", :force => true do |t|
    t.integer  "course_id",           :default => 0,     :null => false
    t.integer  "student_id",          :default => 0,     :null => false
    t.integer  "teacher_id",          :default => 0,     :null => false
    t.string   "question",            :default => "",    :null => false
    t.text     "answer"
    t.boolean  "solved",              :default => false, :null => false
    t.text     "notes"
    t.string   "course_official_id",  :default => "",    :null => false
    t.string   "course_name",         :default => "",    :null => false
    t.string   "student_official_id", :default => "",    :null => false
    t.string   "student_last_name",   :default => "",    :null => false
    t.string   "student_first_name",  :default => "",    :null => false
    t.string   "teacher_official_id", :default => "",    :null => false
    t.string   "teacher_last_name",   :default => "",    :null => false
    t.string   "teacher_first_name",  :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "queries", ["course_id", "student_id"], :name => "index_queries_on_course_id_and_student_id"
  add_index "queries", ["course_id", "teacher_id"], :name => "index_queries_on_course_id_and_teacher_id"
  add_index "queries", ["course_id"], :name => "index_queries_on_course_id"
  add_index "queries", ["student_id"], :name => "index_queries_on_student_id"
  add_index "queries", ["teacher_id"], :name => "index_queries_on_teacher_id"

  create_table "relevances", :force => true do |t|
    t.integer  "entry_id",   :default => 0, :null => false
    t.integer  "keyword_id", :default => 0, :null => false
    t.integer  "value",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relevances", ["entry_id", "keyword_id"], :name => "index_relevances_on_entry_id_and_keyword_id"
  add_index "relevances", ["entry_id"], :name => "index_relevances_on_entry_id"
  add_index "relevances", ["keyword_id"], :name => "index_relevances_on_keyword_id"

  create_table "users", :force => true do |t|
    t.string   "official_id",                             :default => "",    :null => false
    t.string   "login"
    t.string   "email"
    t.string   "last_name",                 :limit => 80
    t.string   "first_name",                :limit => 80
    t.boolean  "is_admin",                                :default => false, :null => false
    t.boolean  "is_teacher",                              :default => false, :null => false
    t.integer  "entries_sum",                             :default => 0,     :null => false
    t.text     "comment"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
