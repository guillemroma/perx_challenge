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

ActiveRecord::Schema.define(version: 2022_10_06_110107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airport_lounge_controls", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "remaining", default: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_airport_lounge_controls_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "standard", default: true
    t.boolean "gold", default: false
    t.boolean "platinium", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "point_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "year"
    t.bigint "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_point_records_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "amount_prior_month", default: 0
    t.bigint "amount", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "reward_elegibles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "free_coffee", default: true
    t.boolean "cash_rebate", default: true
    t.boolean "free_movie_tickets", default: true
    t.boolean "airport_lounge_access", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reward_elegibles_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "free_coffee", default: false
    t.boolean "cash_rebate", default: false
    t.boolean "free_movie_tickets", default: false
    t.boolean "airport_lounge_access", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "tier_controls", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "current_year", default: "standard"
    t.string "last_year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_tier_controls_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "amount"
    t.string "country"
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country"
    t.string "user_type"
    t.date "birthday"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "airport_lounge_controls", "users"
  add_foreign_key "memberships", "users"
  add_foreign_key "point_records", "users"
  add_foreign_key "points", "users"
  add_foreign_key "reward_elegibles", "users"
  add_foreign_key "rewards", "users"
  add_foreign_key "tier_controls", "users"
  add_foreign_key "transactions", "users"
end
