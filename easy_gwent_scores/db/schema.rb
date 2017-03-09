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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170308221030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_rows", force: :cascade do |t|
    t.integer  "board_side_id"
    t.string   "combat_type"
    t.boolean  "commanders_horn_active", default: false
    t.boolean  "weather_active",         default: false
    t.integer  "score",                  default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["board_side_id"], name: "index_board_rows_on_board_side_id", using: :btree
  end

  create_table "board_sides", force: :cascade do |t|
    t.integer  "score",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "round_id"
    t.index ["round_id"], name: "index_board_sides_on_round_id", using: :btree
  end

  create_table "card_plays", id: false, force: :cascade do |t|
    t.integer  "board_side_id"
    t.integer  "board_row_id"
    t.integer  "card_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["board_row_id"], name: "index_card_plays_on_board_row_id", using: :btree
    t.index ["board_side_id"], name: "index_card_plays_on_board_side_id", using: :btree
    t.index ["card_id"], name: "index_card_plays_on_card_id", using: :btree
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "faction_id"
    t.string   "name"
    t.integer  "num_related"
    t.string   "card_type"
    t.string   "combat_row"
    t.integer  "strength"
    t.string   "special_ability"
    t.string   "description"
    t.string   "source"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["faction_id"], name: "index_cards_on_faction_id", using: :btree
  end

  create_table "factions", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "wiki_path"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "number",     default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "board_sides", "rounds"
  add_foreign_key "card_plays", "board_rows"
  add_foreign_key "card_plays", "board_sides"
  add_foreign_key "card_plays", "cards"
  add_foreign_key "cards", "factions"
end
