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

ActiveRecord::Schema[7.0].define(version: 2024_07_05_033710) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "class_sessions", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.date "session_date"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "start_time"
    t.time "end_time"
    t.index ["classroom_id"], name: "index_class_sessions_on_classroom_id"
  end

  create_table "classroom_students", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_classroom_students_on_classroom_id"
    t.index ["user_id"], name: "index_classroom_students_on_user_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.integer "teacher_id", null: false
    t.integer "day_count"
    t.integer "hours_per_class"
    t.decimal "price_per_student", precision: 8, scale: 2
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "students_count", default: 0
    t.integer "final_student_count"
    t.integer "workshop_id"
    t.decimal "regular_price", precision: 8, scale: 2
    t.decimal "discount_percentage", precision: 5, scale: 2
    t.index ["teacher_id"], name: "index_classrooms_on_teacher_id"
    t.index ["workshop_id"], name: "index_classrooms_on_workshop_id"
  end

  create_table "lesson_completions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "lesson_id", null: false
    t.string "status", null: false
    t.datetime "completion_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_completions_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_lesson_completions_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_lesson_completions_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "workshop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workshop_id"], name: "index_lessons_on_workshop_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "estudiante", null: false
    t.string "full_name"
    t.string "phone"
    t.integer "age"
    t.string "country"
    t.string "city"
    t.boolean "previous_experience"
    t.boolean "previous_courses"
    t.string "programming_skill_level"
    t.text "motivation"
    t.text "course_expectations"
    t.text "specific_goals"
    t.boolean "has_reliable_computer"
    t.text "feedback_on_previous_courses"
    t.boolean "approved", default: false
    t.string "payment_method"
    t.string "payment_option"
    t.integer "workshop_id"
    t.string "payment_status"
    t.string "second_payment_proof"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_workshops_on_classroom_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "class_sessions", "classrooms"
  add_foreign_key "classroom_students", "classrooms"
  add_foreign_key "classroom_students", "users"
  add_foreign_key "classrooms", "users", column: "teacher_id"
  add_foreign_key "lesson_completions", "lessons"
  add_foreign_key "lesson_completions", "users"
  add_foreign_key "lessons", "workshops"
  add_foreign_key "workshops", "classrooms"
end
