# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_11_15_175757) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bugs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "priority", default: 0
    t.integer "status", default: 0
    t.bigint "project_id", null: false
    t.bigint "assigned_to_id"
    t.bigint "reported_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_bugs_on_assigned_to_id"
    t.index ["project_id"], name: "index_bugs_on_project_id"
    t.index ["reported_by_id"], name: "index_bugs_on_reported_by_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "bug_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bug_id"], name: "index_comments_on_bug_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "project_users", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "role", default: 2
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bugs", "projects"
  add_foreign_key "bugs", "users", column: "assigned_to_id"
  add_foreign_key "bugs", "users", column: "reported_by_id"
  add_foreign_key "comments", "bugs"
  add_foreign_key "comments", "users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
end
