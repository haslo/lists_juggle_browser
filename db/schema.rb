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

ActiveRecord::Schema.define(version: 20170725162505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conditions", id: :serial, force: :cascade do |t|
    t.integer "pilot_id"
    t.integer "upgrade_id"
    t.string "name"
    t.string "image_path"
    t.string "xws"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "xwing_data_id"
    t.index ["pilot_id"], name: "index_conditions_on_pilot_id"
    t.index ["upgrade_id"], name: "index_conditions_on_upgrade_id"
  end

  create_table "factions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.boolean "is_subfaction"
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

  create_table "pilots", id: :serial, force: :cascade do |t|
    t.integer "ship_id"
    t.integer "faction_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.string "image_path"
    t.integer "xwing_data_id"
    t.index ["faction_id"], name: "index_pilots_on_faction_id"
    t.index ["ship_id"], name: "index_pilots_on_ship_id"
  end

  create_table "ship_combos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archetype_name"
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
    t.string "font_icon_class"
    t.string "xws"
    t.string "size"
    t.integer "xwing_data_id"
    t.index ["size"], name: "index_ships_on_size"
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
    t.string "format"
    t.integer "venue_id"
    t.index ["tournament_type_id"], name: "index_tournaments_on_tournament_type_id"
    t.index ["venue_id"], name: "index_tournaments_on_venue_id"
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
    t.integer "upgrade_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xws"
    t.string "image_path"
    t.integer "xwing_data_id"
    t.index ["upgrade_type_id"], name: "index_upgrades_on_upgrade_type_id"
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

  add_foreign_key "conditions", "pilots"
  add_foreign_key "conditions", "upgrades"
  add_foreign_key "games", "ship_combos", column: "losing_combo_id"
  add_foreign_key "games", "ship_combos", column: "winning_combo_id"
  add_foreign_key "games", "squadrons", column: "losing_squadron_id"
  add_foreign_key "games", "squadrons", column: "winning_squadron_id"
  add_foreign_key "games", "tournaments"
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
  add_foreign_key "tournaments", "tournament_types"
  add_foreign_key "tournaments", "venues"
  add_foreign_key "upgrades", "upgrade_types"
end
