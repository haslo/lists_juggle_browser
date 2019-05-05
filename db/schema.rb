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

ActiveRecord::Schema.define(version: 20190213221521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archetype_name_suggestions", force: :cascade do |t|
    t.bigint "ship_combo_id"
    t.string "ip_address"
    t.string "name_suggestion", null: false
    t.text "comment"
    t.string "status", default: "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ship_combo_id"], name: "index_archetype_name_suggestions_on_ship_combo_id"
  end

  create_table "conditions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "image_path"
    t.string "xws"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ability"
    t.string "image"
  end

  create_table "factions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.integer "ffg"
    t.string "icon"
  end

  create_table "formats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "winning_squadron_id"
    t.integer "losing_squadron_id"
    t.integer "winning_combo_id"
    t.integer "losing_combo_id"
    t.integer "round_number"
    t.string "round_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["losing_combo_id"], name: "index_games_on_losing_combo_id"
    t.index ["losing_squadron_id"], name: "index_games_on_losing_squadron_id"
    t.index ["tournament_id"], name: "index_games_on_tournament_id"
    t.index ["winning_combo_id"], name: "index_games_on_winning_combo_id"
    t.index ["winning_squadron_id"], name: "index_games_on_winning_squadron_id"
  end

  create_table "key_value_store_records", id: :serial, force: :cascade do |t|
    t.string "key"
    t.json "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pilot_alts", force: :cascade do |t|
    t.bigint "pilot_id"
    t.string "image"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pilot_id"], name: "index_pilot_alts_on_pilot_id"
  end

  create_table "pilot_slots", force: :cascade do |t|
    t.bigint "pilot_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pilot_id"], name: "index_pilot_slots_on_pilot_id"
  end

  create_table "pilots", id: :serial, force: :cascade do |t|
    t.integer "ship_id"
    t.integer "faction_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.string "caption"
    t.integer "initiative"
    t.integer "limited"
    t.string "ability"
    t.string "image"
    t.string "artwork"
    t.boolean "hyperspace"
    t.integer "cost"
    t.integer "charges_value"
    t.integer "charges_recovers"
    t.integer "force_value"
    t.integer "force_recovers"
    t.string "force_side"
    t.integer "ffg"
    t.index ["faction_id"], name: "index_pilots_on_faction_id"
    t.index ["ship_id"], name: "index_pilots_on_ship_id"
  end

  create_table "ship_combos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archetype_name"
    t.string "alternate_names", array: true
  end

  create_table "ship_combos_ships", id: false, force: :cascade do |t|
    t.integer "ship_id"
    t.integer "ship_combo_id"
    t.index ["ship_combo_id"], name: "index_ship_combos_ships_on_ship_combo_id"
    t.index ["ship_id"], name: "index_ship_combos_ships_on_ship_id"
  end

  create_table "ship_configurations", id: :serial, force: :cascade do |t|
    t.integer "squadron_id"
    t.integer "pilot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pilot_id"], name: "index_ship_configurations_on_pilot_id"
    t.index ["squadron_id"], name: "index_ship_configurations_on_squadron_id"
  end

  create_table "ship_configurations_upgrades", id: false, force: :cascade do |t|
    t.integer "ship_configuration_id"
    t.integer "upgrade_id"
    t.index ["ship_configuration_id"], name: "index_ship_configurations_upgrades_on_ship_configuration_id"
    t.index ["upgrade_id"], name: "index_ship_configurations_upgrades_on_upgrade_id"
  end

  create_table "ships", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.string "size"
    t.integer "ffg"
    t.string "icon"
    t.index ["size"], name: "index_ships_on_size"
  end

  create_table "slots", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squadrons", id: :serial, force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "points"
    t.integer "swiss_standing"
    t.integer "elimination_standing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "swiss_percentile"
    t.float "elimination_percentile"
    t.integer "ship_combo_id"
    t.string "player_name"
    t.integer "mov"
    t.json "xws"
    t.float "win_loss_ratio_swiss"
    t.float "win_loss_ratio_elimination"
    t.integer "faction_id"
    t.string "name"
    t.index ["ship_combo_id"], name: "index_squadrons_on_ship_combo_id"
    t.index ["tournament_id"], name: "index_squadrons_on_tournament_id"
  end

  create_table "tournament_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", id: :serial, force: :cascade do |t|
    t.date "date"
    t.string "name"
    t.integer "tournament_type_id"
    t.integer "lists_juggler_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "num_players"
    t.integer "round_length"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "venue_id"
    t.bigint "format_id"
    t.index ["format_id"], name: "index_tournaments_on_format_id"
    t.index ["tournament_type_id"], name: "index_tournaments_on_tournament_type_id"
    t.index ["venue_id"], name: "index_tournaments_on_venue_id"
  end

  create_table "upgrade_side_alts", force: :cascade do |t|
    t.bigint "upgrade_side_id"
    t.string "image"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["upgrade_side_id"], name: "index_upgrade_side_alts_on_upgrade_side_id"
  end

  create_table "upgrade_side_slots", force: :cascade do |t|
    t.bigint "upgrade_side_id"
    t.bigint "slot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slot_id"], name: "index_upgrade_side_slots_on_slot_id"
    t.index ["upgrade_side_id"], name: "index_upgrade_side_slots_on_upgrade_side_id"
  end

  create_table "upgrade_sides", force: :cascade do |t|
    t.bigint "upgrade_id"
    t.string "title"
    t.string "upgrade_type"
    t.string "ability"
    t.string "image"
    t.string "artwork"
    t.integer "charges_value"
    t.integer "charges_recovers"
    t.string "attack_arc"
    t.integer "attack_value"
    t.integer "attack_minrange"
    t.integer "attack_maxrange"
    t.boolean "attack_ordnance"
    t.string "device_name"
    t.string "device_type"
    t.string "device_effect"
    t.integer "force_value"
    t.integer "force_recovers"
    t.string "force_side"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ffg"
    t.index ["upgrade_id"], name: "index_upgrade_sides_on_upgrade_id"
  end

  create_table "upgrade_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "font_icon_class"
    t.string "xws"
  end

  create_table "upgrades", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.integer "limited"
    t.integer "cost"
    t.boolean "hyperspace"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_venues_on_city"
    t.index ["country"], name: "index_venues_on_country"
    t.index ["state"], name: "index_venues_on_state"
  end

  add_foreign_key "games", "ship_combos", column: "losing_combo_id"
  add_foreign_key "games", "ship_combos", column: "winning_combo_id"
  add_foreign_key "games", "squadrons", column: "losing_squadron_id"
  add_foreign_key "games", "squadrons", column: "winning_squadron_id"
  add_foreign_key "games", "tournaments"
  add_foreign_key "pilot_alts", "pilots"
  add_foreign_key "pilot_slots", "pilots"
  add_foreign_key "pilots", "factions"
  add_foreign_key "pilots", "ships"
  add_foreign_key "ship_combos_ships", "ship_combos"
  add_foreign_key "ship_combos_ships", "ships"
  add_foreign_key "ship_configurations", "pilots"
  add_foreign_key "ship_configurations", "squadrons"
  add_foreign_key "ship_configurations_upgrades", "ship_configurations"
  add_foreign_key "ship_configurations_upgrades", "upgrades"
  add_foreign_key "squadrons", "factions"
  add_foreign_key "squadrons", "ship_combos"
  add_foreign_key "squadrons", "tournaments"
  add_foreign_key "tournaments", "formats"
  add_foreign_key "tournaments", "tournament_types"
  add_foreign_key "tournaments", "venues"
  add_foreign_key "upgrade_side_alts", "upgrade_sides"
  add_foreign_key "upgrade_side_slots", "slots"
  add_foreign_key "upgrade_side_slots", "upgrade_sides"
  add_foreign_key "upgrade_sides", "upgrades"
end
