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

ActiveRecord::Schema.define(version: 2019_12_08_221058) do

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "itemid"
    t.string "icon"
    t.integer "alch"
    t.integer "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "player_name"
    t.string "player_acc_type"
    t.integer "overall_xp"
    t.integer "overall_lvl"
    t.float "overall_ehp"
    t.integer "attack_xp"
    t.integer "attack_lvl"
    t.float "attack_ehp"
    t.integer "defence_xp"
    t.integer "defence_lvl"
    t.float "defence_ehp"
    t.integer "strength_xp"
    t.integer "strength_lvl"
    t.float "strength_ehp"
    t.integer "hitpoints_xp"
    t.integer "hitpoints_lvl"
    t.float "hitpoints_ehp"
    t.integer "ranged_xp"
    t.integer "ranged_lvl"
    t.float "ranged_ehp"
    t.integer "prayer_xp"
    t.integer "prayer_lvl"
    t.float "prayer_ehp"
    t.integer "magic_xp"
    t.integer "magic_lvl"
    t.float "magic_ehp"
    t.integer "cooking_xp"
    t.integer "cooking_lvl"
    t.float "cooking_ehp"
    t.integer "woodcutting_xp"
    t.integer "woodcutting_lvl"
    t.float "woodcutting_ehp"
    t.integer "fishing_xp"
    t.integer "fishing_lvl"
    t.float "fishing_ehp"
    t.integer "firemaking_xp"
    t.integer "firemaking_lvl"
    t.float "firemaking_ehp"
    t.integer "crafting_xp"
    t.integer "crafting_lvl"
    t.float "crafting_ehp"
    t.integer "smithing_xp"
    t.integer "smithing_lvl"
    t.float "smithing_ehp"
    t.integer "mining_xp"
    t.integer "mining_lvl"
    t.float "mining_ehp"
    t.integer "runecraft_xp"
    t.integer "runecraft_lvl"
    t.float "runecraft_ehp"
    t.integer "potential_p2p"
    t.integer "overall_rank"
    t.integer "attack_rank"
    t.integer "defence_rank"
    t.integer "strength_rank"
    t.integer "hitpoints_rank"
    t.integer "ranged_rank"
    t.integer "prayer_rank"
    t.integer "magic_rank"
    t.integer "cooking_rank"
    t.integer "woodcutting_rank"
    t.integer "fishing_rank"
    t.integer "firemaking_rank"
    t.integer "crafting_rank"
    t.integer "smithing_rank"
    t.integer "mining_rank"
    t.integer "runecraft_rank"
    t.integer "attack_xp_day_start"
    t.integer "attack_xp_day_max"
    t.float "attack_ehp_day_start"
    t.float "attack_ehp_day_max"
    t.integer "attack_xp_week_start"
    t.integer "attack_xp_week_max"
    t.float "attack_ehp_week_start"
    t.float "attack_ehp_week_max"
    t.integer "attack_xp_month_start"
    t.integer "attack_xp_month_max"
    t.float "attack_ehp_month_start"
    t.float "attack_ehp_month_max"
    t.integer "attack_xp_year_start"
    t.integer "attack_xp_year_max"
    t.float "attack_ehp_year_start"
    t.float "attack_ehp_year_max"
    t.integer "strength_xp_day_start"
    t.integer "strength_xp_day_max"
    t.float "strength_ehp_day_start"
    t.float "strength_ehp_day_max"
    t.integer "strength_xp_week_start"
    t.integer "strength_xp_week_max"
    t.float "strength_ehp_week_start"
    t.float "strength_ehp_week_max"
    t.integer "strength_xp_month_start"
    t.integer "strength_xp_month_max"
    t.float "strength_ehp_month_start"
    t.float "strength_ehp_month_max"
    t.integer "strength_xp_year_start"
    t.integer "strength_xp_year_max"
    t.float "strength_ehp_year_start"
    t.float "strength_ehp_year_max"
    t.integer "defence_xp_day_start"
    t.integer "defence_xp_day_max"
    t.float "defence_ehp_day_start"
    t.float "defence_ehp_day_max"
    t.integer "defence_xp_week_start"
    t.integer "defence_xp_week_max"
    t.float "defence_ehp_week_start"
    t.float "defence_ehp_week_max"
    t.integer "defence_xp_month_start"
    t.integer "defence_xp_month_max"
    t.float "defence_ehp_month_start"
    t.float "defence_ehp_month_max"
    t.integer "defence_xp_year_start"
    t.integer "defence_xp_year_max"
    t.float "defence_ehp_year_start"
    t.float "defence_ehp_year_max"
    t.integer "hitpoints_xp_day_start"
    t.integer "hitpoints_xp_day_max"
    t.float "hitpoints_ehp_day_start"
    t.float "hitpoints_ehp_day_max"
    t.integer "hitpoints_xp_week_start"
    t.integer "hitpoints_xp_week_max"
    t.float "hitpoints_ehp_week_start"
    t.float "hitpoints_ehp_week_max"
    t.integer "hitpoints_xp_month_start"
    t.integer "hitpoints_xp_month_max"
    t.float "hitpoints_ehp_month_start"
    t.float "hitpoints_ehp_month_max"
    t.integer "hitpoints_xp_year_start"
    t.integer "hitpoints_xp_year_max"
    t.float "hitpoints_ehp_year_start"
    t.float "hitpoints_ehp_year_max"
    t.integer "ranged_xp_day_start"
    t.integer "ranged_xp_day_max"
    t.float "ranged_ehp_day_start"
    t.float "ranged_ehp_day_max"
    t.integer "ranged_xp_week_start"
    t.integer "ranged_xp_week_max"
    t.float "ranged_ehp_week_start"
    t.float "ranged_ehp_week_max"
    t.integer "ranged_xp_month_start"
    t.integer "ranged_xp_month_max"
    t.float "ranged_ehp_month_start"
    t.float "ranged_ehp_month_max"
    t.integer "ranged_xp_year_start"
    t.integer "ranged_xp_year_max"
    t.float "ranged_ehp_year_start"
    t.float "ranged_ehp_year_max"
    t.integer "prayer_xp_day_start"
    t.integer "prayer_xp_day_max"
    t.float "prayer_ehp_day_start"
    t.float "prayer_ehp_day_max"
    t.integer "prayer_xp_week_start"
    t.integer "prayer_xp_week_max"
    t.float "prayer_ehp_week_start"
    t.float "prayer_ehp_week_max"
    t.integer "prayer_xp_month_start"
    t.integer "prayer_xp_month_max"
    t.float "prayer_ehp_month_start"
    t.float "prayer_ehp_month_max"
    t.integer "prayer_xp_year_start"
    t.integer "prayer_xp_year_max"
    t.float "prayer_ehp_year_start"
    t.float "prayer_ehp_year_max"
    t.integer "magic_xp_day_start"
    t.integer "magic_xp_day_max"
    t.float "magic_ehp_day_start"
    t.float "magic_ehp_day_max"
    t.integer "magic_xp_week_start"
    t.integer "magic_xp_week_max"
    t.float "magic_ehp_week_start"
    t.float "magic_ehp_week_max"
    t.integer "magic_xp_month_start"
    t.integer "magic_xp_month_max"
    t.float "magic_ehp_month_start"
    t.float "magic_ehp_month_max"
    t.integer "magic_xp_year_start"
    t.integer "magic_xp_year_max"
    t.float "magic_ehp_year_start"
    t.float "magic_ehp_year_max"
    t.integer "cooking_xp_day_start"
    t.integer "cooking_xp_day_max"
    t.float "cooking_ehp_day_start"
    t.float "cooking_ehp_day_max"
    t.integer "cooking_xp_week_start"
    t.integer "cooking_xp_week_max"
    t.float "cooking_ehp_week_start"
    t.float "cooking_ehp_week_max"
    t.integer "cooking_xp_month_start"
    t.integer "cooking_xp_month_max"
    t.float "cooking_ehp_month_start"
    t.float "cooking_ehp_month_max"
    t.integer "cooking_xp_year_start"
    t.integer "cooking_xp_year_max"
    t.float "cooking_ehp_year_start"
    t.float "cooking_ehp_year_max"
    t.integer "woodcutting_xp_day_start"
    t.integer "woodcutting_xp_day_max"
    t.float "woodcutting_ehp_day_start"
    t.float "woodcutting_ehp_day_max"
    t.integer "woodcutting_xp_week_start"
    t.integer "woodcutting_xp_week_max"
    t.float "woodcutting_ehp_week_start"
    t.float "woodcutting_ehp_week_max"
    t.integer "woodcutting_xp_month_start"
    t.integer "woodcutting_xp_month_max"
    t.float "woodcutting_ehp_month_start"
    t.float "woodcutting_ehp_month_max"
    t.integer "woodcutting_xp_year_start"
    t.integer "woodcutting_xp_year_max"
    t.float "woodcutting_ehp_year_start"
    t.float "woodcutting_ehp_year_max"
    t.integer "fishing_xp_day_start"
    t.integer "fishing_xp_day_max"
    t.float "fishing_ehp_day_start"
    t.float "fishing_ehp_day_max"
    t.integer "fishing_xp_week_start"
    t.integer "fishing_xp_week_max"
    t.float "fishing_ehp_week_start"
    t.float "fishing_ehp_week_max"
    t.integer "fishing_xp_month_start"
    t.integer "fishing_xp_month_max"
    t.float "fishing_ehp_month_start"
    t.float "fishing_ehp_month_max"
    t.integer "fishing_xp_year_start"
    t.integer "fishing_xp_year_max"
    t.float "fishing_ehp_year_start"
    t.float "fishing_ehp_year_max"
    t.integer "firemaking_xp_day_start"
    t.integer "firemaking_xp_day_max"
    t.float "firemaking_ehp_day_start"
    t.float "firemaking_ehp_day_max"
    t.integer "firemaking_xp_week_start"
    t.integer "firemaking_xp_week_max"
    t.float "firemaking_ehp_week_start"
    t.float "firemaking_ehp_week_max"
    t.integer "firemaking_xp_month_start"
    t.integer "firemaking_xp_month_max"
    t.float "firemaking_ehp_month_start"
    t.float "firemaking_ehp_month_max"
    t.integer "firemaking_xp_year_start"
    t.integer "firemaking_xp_year_max"
    t.float "firemaking_ehp_year_start"
    t.float "firemaking_ehp_year_max"
    t.integer "crafting_xp_day_start"
    t.integer "crafting_xp_day_max"
    t.float "crafting_ehp_day_start"
    t.float "crafting_ehp_day_max"
    t.integer "crafting_xp_week_start"
    t.integer "crafting_xp_week_max"
    t.float "crafting_ehp_week_start"
    t.float "crafting_ehp_week_max"
    t.integer "crafting_xp_month_start"
    t.integer "crafting_xp_month_max"
    t.float "crafting_ehp_month_start"
    t.float "crafting_ehp_month_max"
    t.integer "crafting_xp_year_start"
    t.integer "crafting_xp_year_max"
    t.float "crafting_ehp_year_start"
    t.float "crafting_ehp_year_max"
    t.integer "smithing_xp_day_start"
    t.integer "smithing_xp_day_max"
    t.float "smithing_ehp_day_start"
    t.float "smithing_ehp_day_max"
    t.integer "smithing_xp_week_start"
    t.integer "smithing_xp_week_max"
    t.float "smithing_ehp_week_start"
    t.float "smithing_ehp_week_max"
    t.integer "smithing_xp_month_start"
    t.integer "smithing_xp_month_max"
    t.float "smithing_ehp_month_start"
    t.float "smithing_ehp_month_max"
    t.integer "smithing_xp_year_start"
    t.integer "smithing_xp_year_max"
    t.float "smithing_ehp_year_start"
    t.float "smithing_ehp_year_max"
    t.integer "mining_xp_day_start"
    t.integer "mining_xp_day_max"
    t.float "mining_ehp_day_start"
    t.float "mining_ehp_day_max"
    t.integer "mining_xp_week_start"
    t.integer "mining_xp_week_max"
    t.float "mining_ehp_week_start"
    t.float "mining_ehp_week_max"
    t.integer "mining_xp_month_start"
    t.integer "mining_xp_month_max"
    t.float "mining_ehp_month_start"
    t.float "mining_ehp_month_max"
    t.integer "mining_xp_year_start"
    t.integer "mining_xp_year_max"
    t.float "mining_ehp_year_start"
    t.float "mining_ehp_year_max"
    t.integer "runecraft_xp_day_start"
    t.integer "runecraft_xp_day_max"
    t.float "runecraft_ehp_day_start"
    t.float "runecraft_ehp_day_max"
    t.integer "runecraft_xp_week_start"
    t.integer "runecraft_xp_week_max"
    t.float "runecraft_ehp_week_start"
    t.float "runecraft_ehp_week_max"
    t.integer "runecraft_xp_month_start"
    t.integer "runecraft_xp_month_max"
    t.float "runecraft_ehp_month_start"
    t.float "runecraft_ehp_month_max"
    t.integer "runecraft_xp_year_start"
    t.integer "runecraft_xp_year_max"
    t.float "runecraft_ehp_year_start"
    t.float "runecraft_ehp_year_max"
    t.integer "overall_xp_day_start"
    t.integer "overall_xp_day_max"
    t.float "overall_ehp_day_start"
    t.float "overall_ehp_day_max"
    t.integer "overall_xp_week_start"
    t.integer "overall_xp_week_max"
    t.float "overall_ehp_week_start"
    t.float "overall_ehp_week_max"
    t.integer "overall_xp_month_start"
    t.integer "overall_xp_month_max"
    t.float "overall_ehp_month_start"
    t.float "overall_ehp_month_max"
    t.integer "overall_xp_year_start"
    t.integer "overall_xp_year_max"
    t.float "overall_ehp_year_start"
    t.float "overall_ehp_year_max"
    t.float "ttm_lvl"
    t.float "ttm_xp"
    t.integer "clues_all"
    t.integer "clues_beginner"
    t.integer "clues_all_rank"
    t.integer "clues_beginner_rank"
    t.float "combat_lvl"
    t.boolean "hcim_has_died", default: false
    t.datetime "hcim_has_died_registered_at"
    t.integer "obor_kc"
    t.integer "bryo_kc"
    t.integer "obor_kc_rank"
    t.integer "bryo_kc_rank"
    t.integer "lms_score"
    t.integer "lms_rank"
    t.integer "failed_updates", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "pass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
