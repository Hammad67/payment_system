# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_20_080720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "features", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.string "code", limit: 20, null: false
    t.integer "unit_price", null: false
    t.integer "max_unit_limit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_id"
  end

  create_table "features_plans", id: false, force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "feature_id", null: false
    t.index ["feature_id", "plan_id"], name: "index_features_plans_on_feature_id_and_plan_id"
    t.index ["plan_id", "feature_id"], name: "index_features_plans_on_plan_id_and_feature_id"
  end

  create_table "featureusages", force: :cascade do |t|
    t.integer "total_extra_units"
    t.boolean "is_used"
    t.bigint "feature_id", null: false
    t.bigint "buyer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "no_of_exeeded_units"
    t.integer "plan_id"
    t.index ["buyer_id"], name: "index_featureusages_on_buyer_id"
    t.index ["feature_id"], name: "index_featureusages_on_feature_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.integer "monthly_fee", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_id"
    t.string "stripe_plan_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "stripe_subscription_id"
    t.bigint "plan_id", null: false
    t.bigint "buyer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "is_active", default: false
    t.index ["buyer_id"], name: "index_subscriptions_on_buyer_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "billing_day"
    t.bigint "buyer_id"
    t.bigint "subscription_id"
    t.boolean "is_successfull", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "plan_id"
    t.integer "amount"
    t.index ["buyer_id"], name: "index_transactions_on_buyer_id"
    t.index ["subscription_id"], name: "index_transactions_on_subscription_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", limit: 20, null: false
    t.integer "users", default: 0
    t.integer "type", default: 0
    t.integer "integer", default: 0
    t.string "stripe_cust_id"
    t.string "stripe_source_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "featureusages", "features"
  add_foreign_key "featureusages", "users", column: "buyer_id"
  add_foreign_key "subscriptions", "users", column: "buyer_id"
  add_foreign_key "transactions", "users", column: "buyer_id"
end
