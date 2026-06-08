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

ActiveRecord::Schema[8.1].define(version: 2026_06_08_095214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.decimal "goal_amount", precision: 12, scale: 2
    t.string "slug"
    t.text "story"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_campaigns_on_slug", unique: true
  end

  create_table "donation_options", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.boolean "featured", default: false, null: false
    t.string "label"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_donation_options_on_campaign_id"
  end

  create_table "donations", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "dedication_message"
    t.integer "display_preference", default: 0, null: false
    t.string "donor_email"
    t.string "donor_name"
    t.integer "frequency", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_donations_on_campaign_id"
  end

  add_foreign_key "donation_options", "campaigns"
  add_foreign_key "donations", "campaigns"
end
