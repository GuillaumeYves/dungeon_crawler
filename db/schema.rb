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

ActiveRecord::Schema[7.2].define(version: 2024_10_07_103613) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_inventories", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_inventories_on_character_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "character_class"
    t.bigint "gold", default: 0
    t.bigint "health", default: 100
    t.bigint "max_health", default: 100
    t.bigint "min_physical_damage", default: 5
    t.bigint "max_physical_damage", default: 10
    t.bigint "min_magic_damage", default: 5
    t.bigint "max_magic_damage", default: 10
    t.bigint "armor", default: 5
    t.bigint "magic_resistance", default: 5
    t.decimal "dodge_chance", precision: 5, scale: 2, default: "0.02"
    t.decimal "critical_strike_chance", precision: 5, scale: 2, default: "0.05"
    t.decimal "critical_strike_damage", precision: 5, scale: 2, default: "1.5"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "main_hand_id"
    t.bigint "off_hand_id"
    t.bigint "head_id"
    t.bigint "chest_id"
    t.bigint "legs_id"
    t.bigint "feet_id"
    t.bigint "dungeon_stage", default: 1
    t.bigint "experience", default: 0
    t.bigint "max_experience", default: 100
    t.bigint "mana", default: 100
    t.bigint "max_mana", default: 100
    t.bigint "level", default: 1
    t.integer "skill_points", default: 0
    t.integer "spell_id"
    t.index ["chest_id"], name: "index_characters_on_chest_id"
    t.index ["feet_id"], name: "index_characters_on_feet_id"
    t.index ["head_id"], name: "index_characters_on_head_id"
    t.index ["legs_id"], name: "index_characters_on_legs_id"
    t.index ["main_hand_id"], name: "index_characters_on_main_hand_id"
    t.index ["off_hand_id"], name: "index_characters_on_off_hand_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "characters_spells", id: false, force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "spell_id", null: false
    t.index ["character_id", "spell_id"], name: "index_characters_spells_on_character_id_and_spell_id"
    t.index ["spell_id", "character_id"], name: "index_characters_spells_on_spell_id_and_character_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "slot_type"
    t.string "item_type"
    t.bigint "health"
    t.bigint "min_physical_damage"
    t.bigint "max_physical_damage"
    t.bigint "min_magic_damage"
    t.bigint "max_magic_damage"
    t.bigint "armor"
    t.bigint "magic_resistance"
    t.decimal "dodge_chance", precision: 5, scale: 2
    t.decimal "critical_strike_chance", precision: 5, scale: 2
    t.decimal "critical_strike_damage", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_inventory_id", null: true
    t.index ["character_inventory_id"], name: "index_items_on_character_inventory_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.bigint "health"
    t.bigint "max_health"
    t.bigint "min_physical_damage"
    t.bigint "max_physical_damage"
    t.bigint "min_magic_damage"
    t.bigint "max_magic_damage"
    t.bigint "armor"
    t.bigint "magic_resistance"
    t.decimal "dodge_chance", precision: 5, scale: 2, default: "0.02"
    t.decimal "critical_strike_chance", precision: 5, scale: 2, default: "0.05"
    t.decimal "critical_strike_damage", precision: 5, scale: 2, default: "1.5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scrolls", force: :cascade do |t|
    t.string "name"
    t.bigint "spell_id", null: false
    t.bigint "level_required"
    t.string "description"
    t.string "class_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_inventory_id", null: true
    t.index ["character_inventory_id"], name: "index_scrolls_on_character_inventory_id"
    t.index ["spell_id"], name: "index_scrolls_on_spell_id"
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.string "class_required"
    t.boolean "unlocked", default: false
    t.string "spell_type"
    t.bigint "mana_cost"
    t.bigint "level_required"
    t.bigint "cooldown"
    t.bigint "damage"
    t.string "damage_type"
    t.string "effect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "base_cooldown"
    t.integer "rank", default: 1
    t.integer "character_id"
    t.string "description"
    t.string "spell_rank"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "character_inventories", "characters"
  add_foreign_key "characters", "items", column: "chest_id"
  add_foreign_key "characters", "items", column: "feet_id"
  add_foreign_key "characters", "items", column: "head_id"
  add_foreign_key "characters", "items", column: "legs_id"
  add_foreign_key "characters", "items", column: "main_hand_id"
  add_foreign_key "characters", "items", column: "off_hand_id"
  add_foreign_key "characters", "users"
  add_foreign_key "items", "character_inventories"
  add_foreign_key "scrolls", "character_inventories"
  add_foreign_key "scrolls", "spells"
end
