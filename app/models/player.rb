require 'open-uri'

class Player < ActiveRecord::Base
  before_update :register_hcim_death,
    if: Proc.new { |player| player.player_acc_type_was == 'HCIM' \
                            && player.player_acc_type == 'IM' }

  SKILLS = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
            "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
            "smithing", "mining", "runecraft", "overall"]

  TIMES = ["day", "week", "month", "year"]

  ACCOUNT_TYPES = %w[Reg IM HCIM UIM]
  ACCOUNT_TYPE_ANCESTORS = {
    UIM: %w[IM Reg],
    HCIM: %w[IM Reg],
    IM: %w[Reg]
  }

  # This is the canonical list of supporter. It is used to generate the list
  # of supporters on both home page and the about us page. It also contains
  # the flair image and other styling applied to supporters names wherever
  # they appear.
  # Adding a new supporter:
  #   1. Add a new entry this list as a hash {name: "supporter_name"}
  #   2. Add an image after their name by adding the key :flair_after
  #   3. Add an image before their  name by adding the key :flair_before
  #   4. Apply arbitrary css by adding the key :other_css
  #   5. If any new images were required, be sure to add them to app/assests/images
  SUPPORTERS = [{name: "Bargan", amount: 260.82, date: "2018-02-02"},
                {name: "Ikiji", amount: 107.28, date: "2018-09-12", flair_after: "flairs/Mystery_box.png"},
                {name: "Vagae", amount: 100, date: "2019-08-25", flair_after: "flairs/Strange_skull.png"},
                {name: "M00MARCITO", amount: 100, date: "2020-03-24"},
                {name: "Tele Crab", amount: 100, date: "2020-05-24", flair_before: "flairs/dark_crab.png", flair_after: "flairs/crab_claw.png"},
                {name: "a q p IM"},
                {name: "Netbook Pro", flair_after: "flairs/malta_flag.png"},
                {name: "tannerdino", amount: 7.69, date: "2018-11-14", flair_after: "items/Mossy_key.png"},
                {name: "Based F2P IM", amount: 70, date: "2019-10-05", flair_after: "IM.png"},
                {name: "Anonymous", amount: 60, date: "2018-01-31", no_link: true},
                {name: "Obor", amount: 60, date: "2018-01-31", flair_before: "flairs/shamanmask.png", flair_after: "flairs/oborclub.png"},
                {name: "Pawz", amount: 55.5, date: "2018-02-01", flair_after: "flairs/rs3helm.png"},
                {name: "DJ9", amount: 50, date: "2018-04-18", flair_after: "flairs/73_hitsplat.png"},
                {name: "Metan", amount: 50, date: "2019-02-13", flair_after: "flairs/Rune_essence.png"},
                {name: "Xliff", amount: 50, date: "2020-05-30", flair_after: "flairs/Air_tiara.gif"},
                {name: "GOLB f2p", amount: 45, date: "2019-06-05", flair_after: "flairs/golb2.png", other_css: ["color: #66ffff"]},
                {name: "Freckled Kid", amount: 41.85, flair_after: "flairs/burnt_bones.png"},
                {name: "Romans ch 12", amount: 40, date: "2019-04-13"},
                {name: "Gl4Head", amount: 30, flair_after: "flairs/fighting_boots.png"},
                {name: "cwismis noob", flair_after: "flairs/christmas_tree.png"},
                {name: "Crawler", flair_after: "flairs/flesh_crawler.png"},
                {name: "Ticket Farm", date: "2019-07-05", flair_after: "flairs/genie_head.png"},
                {name: "Wooper", flair_after: "flairs/wooper.png"},
                {name: "Earfs"},
                {name: "minlvlskilla", flair_after: "flairs/3.png"},
                {name: "Fe F2P", amount: 25, date: "2018-06-21", flair_after: "flairs/skulled.png"},
                {name: "UIM STK F2P", amount: 20, date: "2018-09-20", flair_after: "items/Rune_scimitar.gif"},
                    {name: "IM 73 COMBAT", amount: 20, date: "2018-09-20", flair_after: "flairs/skulled.png"}, # request of UIM STK F2P
                {name: "vpered", amount: 20, date: "2020-05-20", flair_after: "flairs/russia_flag.png"},
                {name: "Anonymous", amount: 20, date: "2019-07-19", no_link: true},
                {name: "seid", amount: 20, date: "2019-11-18"},
                {name: "Zubat", amount: 20, date: "2019-12-02", flair_after: "flairs/zubat.png", other_css: ["color: #8BB4EE"]},
                {name: "Varvali", amount: 20, date: "2020-05-12"},
                {name: "Ywal", amount: 20, date: "2020-06-03", flair_after: "flairs/hole.png", other_css: ["color: #C9AD79"]},
                {name: "Iron of One", amount: 18, date: "2018-12-24", flair_after: "items/Dark_cavalier.png"},
                {name: "Xan So", amount: 15, date: "2018-11-13", flair_after: "items/Maple_shortbow.png"},
                {name: "ColdFingers3", amount: 15, date: "2019-04-29", flair_after: "flairs/Snow_imp_gloves.png"},
                {name: "Brim haven", amount: 15, date: "2019-05-31", flair_after: "flairs/ceres.png"},
                {name: "Anonymous", amount: 15, date: "2019-10-12", no_link: true},
                {name: "TrustNoBanks", amount: 13, date: "2019-10-06", flair_after: "flairs/Green_halloween_mask.png", other_css: ["color: #0e7912"]},
                {name: "Yewsless", amount: 11, date: "2018-03-11", flair_after: "items/Yew_logs.gif"},
                {name: "F2P Lukie", amount: 10, date: "2018-01-31", flair_after: "flairs/tea.png"},
                {name: "Tame My Wild", amount: 10, date: "2018-02-06", flair_after: "flairs/dog.png"},
                {name: "Faij", amount: 10, date: "2018-03-06", flair_after: "flairs/frog.png"},
                {name: "Frogmask", flair_after: "flairs/frog.png"},
                {name: "FitMC", amount: 10, date: "2018-03-13", flair_after: "flairs/anchovy_pizza.png"},
                {name: "Pink skirt", amount: 10, date: "2018-05-18", flair_after: "flairs/pink_skirt.png"},
                {name: "MA5ON", amount: 10, date: "2018-11-15", flair_after: "items/Diamond.gif"},
                {name: "NoQuestsHCIM", amount: 10, date: "2018-12-02", flair_after: "flairs/noquest.png"},
                {name: "Sir BoJo", amount: 10, date: "2018-12-03", flair_after: "items/Rune_mace.gif"},
                {name: "f2p Ello", amount: 10, date: "2018-12-05", flair_after: "items/Book_of_knowledge.png"},
                {name: "Sad Jesus", amount: 10, date: "2019-01-19", flair_after: "flairs/sad_jesus.png"},
                {name: "Cas F2P HC", amount: 10, date: "2019-01-30", flair_after: "items/Big_bones.gif"},
                {name: "UIM Dakota", amount: 10, date: "2019-02-26", flair_after: "flairs/Cadava_berries.png"},
                {name: "F2P Jords", amount: 10, date: "2019-03-17", flair_after: "flairs/Druidic_wreath.png"},
                {name: "Feature", amount: 10, date: "2019-14-04", flair_after: "flairs/camel.png"},
                {name: "Steel Afro", amount: 10, date: "2019-05-16"},
                {name: "Your Bearr", amount: 10, date: "2019-06-04", flair_after: "flairs/Bear_feet.png"},
                {name: "UIM TMW", amount: 10, date: "2019-07-19"},
                {name: "Bonk Loot", amount: 10, date: "2019-08-27", flair_after: "flairs/Amulet_of_power.png"},
                {name: "iron korbah", amount: 10, date: "2019-09-27"},
                {name: "ASCMA2828Z", amount: 10, date: "2019-11-16", flair_after: "flairs/Earth_rune.png"},
                {name: "Exile Myth", amount: 10, date: "2019-12-23", flair_after: "flairs/cwars_gold_helm.png"},
                {name: "F2P_Poke_Btw", amount: 10, date: "2020-01-12"},
                {name: "SmellyPooo", amount: 10, date: "2020-02-14"},
                {name: "Solo Tricket", amount: 10, flair_after: "flairs/Jester_cape.png"},
                {name: "Gem Shop", amount: 10, flair_after: "items/Ruby.gif"},
                {name: "I go by zach", amount: 10, date: "2020-03-12", flair_after: "flairs/Spade.png"},
                {name: "Hagl", amount: 20, date: "2020-06-15"},
                {name: "Vanity Pride", amount: 10, date: "2020-03-26", flair_after: "flairs/Blue_partyhat.png"},
                {name: "f2p HClM btw", amount: 10, date: "2020-04-07", flair_after: "flairs/Mole_slippers.png"},
                {name: "Hnn 40", amount: 10, date: "2020-04-08", flair_after: "items/Rune_scimitar.gif", other_css: ["color: #850000"]},
                {name: "Ultimate F2P", amount: 10, date: "2020-04-10", flair_after: "flairs/Mole_slippers.png"},
                {name: "Don Rinus", amount: 10, date: "2020-04-26", flair_after: "flairs/Shoulder_parrot.png"},
                {name: "water9", amount: 10, date: "2020-05-01", flair_after: "items/Water_rune.gif"},
                {name: "Laskati", amount: 10, date: "2020-05-16", flair_after: "flairs/wise_old_man.png"},
                {name: "BigFootTall", amount: 10, date: "2020-06-16", flair_after: "flairs/BigFootTall.png"},
                {name: "Ghost Bloke", amount: 8, date: "2018-12-13", flair_after: "flairs/ghost_bloke.png"},
                {name: "For Ulven", amount: 7.77, date: "2018-03-11", flair_after: "flairs/wolf.png"},
                {name: "Fe Apes", amount: 7.69, date: "2018-12-14", flair_after: "flairs/fe_apes.jpg"},
                {name: "Im Ronin BTW", amount: 7.5, date: "2020-05-17"},
                {name: "Playing Fe", amount: 7, date: "2018-04-26", flair_after: "flairs/salmon.png"},
                {name: "ZINJAN", amount: 6.66, date: "2018-05-18", flair_after: "flairs/ZINJANTHROPI.png"},
                {name: "Snooz Button", amount: 6.66, date: "2018-06-03", flair_after: "flairs/macaroni.png"},
                {name: "Valleyman6", amount: 6.64, date: "2018-06-15", flair_after: "flairs/uk_flag.png"},
                {name: "i drink fiji", amount: 6, date: "2018-05-06", flair_after: "flairs/blue_cape.png"},
                {name: "5th Teletuby", amount: 6, date: "2020-03-29", flair_after: "flairs/Easter_basket.png"},
                {name: "Uxeef", amount: 5.96, date: "2018-09-17"},
                {name: "Lilypad19", amount: 5.69, date: "2020-01-23"},
                {name: "Adentia", amount: 5.55, date: "2018-12-03", flair_after: "flairs/danish_flag.png"},
                {name: "threewaygang"},
                {name: "Yellow bead", amount: 5.38, date: "2018-05-02", flair_after: "flairs/yellow_bead.png"},
                {name: "70 Crafting", amount: 5.08, date: "2020-05-06", flair_after: "flairs/diamond_amulet_u.png"},
                {name: "IronMace Din", amount: 5, date: "2018-02-18", flair_after: "flairs/maceblur2.png"},
                {name: "HCIM_btw_fev", amount: 5, date: "2018-02-05", flair_after: "flairs/kitten.png"},
                {name: "citnA", amount: 5, date: "2018-02-06", flair_after: "flairs/bronzehelm.png"},
                {name: "Lea Sinclair", amount: 5, date: "2018-02-09", flair_after: "flairs/cupcake.png"},
                {name: "lRAIDERSS", amount: 5, date: "2018-02-10", flair_after: "flairs/raiders3.png"},
                {name: "Sofacanlazy", amount: 5, date: "2018-02-11", flair_after: "flairs/australia-flag.png"},
                {name: "I love rs", amount: 5, date: "2018-02-18", flair_after: "flairs/tank.png"},
                {name: "Say F2p Ult", amount: 5, date: "2018-03-01", flair_after: "flairs/santa.png"},
                {name: "Irish Woof", amount: 5, date: "2018-03-04", flair_after: "flairs/leprechaun2.png"},
                {name: "Leftoverover", amount: 5, date: "2018-04-04", flair_after: "flairs/rope.png"},
                {name: "Drae", amount: 5, date: "2018-05-08", flair_after: "flairs/rsz_dshield.png"},
                {name: "David BBQ", amount: 5, date: "2018-05-18", flair_after: "flairs/cooked_chicken.png"},
                {name: "Schwifty Bud", amount: 5, date: "2018-05-26", flair_after: "flairs/rick_sanchez.png", other_css: ["font-family: Script", "font-variant: small-caps"]},
                {name: "UI Pain", amount: 5, date: "2018-06-10", flair_after: "flairs/steel_axe.png"},
                {name: "Bronze axxe", amount: 5, date: "2020-03-12", flair_after: "flairs/Bronze_axe.png"},
                {name: "oLd Sko0l", amount: 5, date: "2018-09-16"},
                {name: "WishengradHC", amount: 5, date: "2018-10-23", flair_after: "flairs/bowser.png"},
                {name: "n4ckerd", amount: 5, date: "2018-11-17", flair_after: "items/Gilded_med_helm.png"},
                {name: "InsurgentF2P", amount: 5, date: "2019-01-01", flair_after: "skills/defence.png"},
                {name: "SapphireHam", amount: 5, date: "2019-01-11", flair_after: "items/Coal.gif"},
                {name: "Doublessssss", amount: 5, date: "2019-01-12"},
                {name: "xmymwf609", amount: 5, date: "2019-01-24"},
                {name: "Onnn", amount: 5, date: "2019-02-03", flair_after: "flairs/canada-flag.png"},
                {name: "Shade_Core", date: "2019-02-08", amount: 5, flair_after: "flairs/shade_core.png"},
                {name: "F2P UIM OREO", amount: 5, date: "2019-02-18", flair_after: "flairs/f2p_uim_oreo.jpg"},
                {name: "HCBown", amount: 5, date: "2019-03-04"},
                {name: "Dukeddd", amount: 5, date: "2019-03-06"},
                {name: "one a time", amount: 5, date: "2019-03-06"},
                {name: "DansPotatoe", date: "2019-03-13", flair_after: "items/Potato.png"},
                {name: "Wizards Foot", amount: 5, date: "2019-03-15", flair_after: "flairs/Wizards_Foot_flair.png"},
                {name: "Hardcore VFL", amount: 5, date: "2019-03-23", flair_after: "HCIM.png"},
                {name: "Pizzarrhea", amount: 5, date: "2019-03-23", flair_after: "flairs/pizzarrhea.gif"},
                {name: "bemanisows", amount: 5, date: "2019-03-26", flair_after: "flairs/vannaka.png"},
                {name: "Dusty Lime", amount: 5, date: "2019-03-27", flair_after: "items/Rune_chainbody.gif"},
                {name: "Brantrout", amount: 5, date: "2019-04-02", flair_after: "items/Trout.gif"},
                {name: "f2p uim nerd", amount: 5, date: "2019-04-09"},
                {name: "Arizer Air", amount: 5, date: "2019-04-15", flair_after: "flairs/chicken_wing.png"},
                {name: "Irondish", amount: 5, date: "2019-04-20", flair_after: "flairs/egg.png"},
                {name: "Maze", amount: 5, date: "2019-04-21", flair_after: "flairs/mysterious.png"},
                {name: "P1J", amount: 5, date: "2019-04-23"},
                {name: "the f2p uim", amount: 5, date: "2019-04-26", flair_after: "flairs/Green_partyhat.png"},
                {name: "Kill the Ego", amount: 5, date: "2019-05-12"},
                {name: "BALN", amount: 5, date: "2019-05-16"},
                {name: "Kristelee", amount: 5, date: "2019-06-26"},
                {name: "Politiken", amount: 5, date: "2019-06-30", flair_after: "flairs/danish_flag.png"},
                {name: "UIMfreebie", amount: 5, date: "2019-08-24", flair_after: "flairs/Fancy_boots.png"},
                {name: "jane uwu", amount: 5, date: "2019-08-28", flair_after: "flairs/Dutch_flag.png"},
                {name: "ginormouskat", amount: 5, date: "2019-09-28"},
                {name: "Kankahboef", amount: 5, date: "2019-10-18", flair_after: "flairs/thieving.png"},
                {name: "Aquaruim", amount: 5, date: "2019-10-23"},
                {name: "sexychocolat", amount: 5, date: "2019-11-04", flair_after: "flairs/Chocolate_bar.png"},
                {name: "thejinjoking", amount: 5, date: "2019-11-20"},
                {name: "Anonymous", amount: 5, date: "2019-11-25", no_link: true},
                {name: "ThaneCore", amount: 5, date: "2019-12-08"},
                {name: "Hc Eudu", amount: 5, date: "2019-12-15", flair_after: "flairs/hitsplat_zero.png"},
                {name: "h o k i e s", amount: 5, date: "2019-12-21", flair_after: "flairs/Event_rpg.png"},
                {name: "Futile_Me", amount: 5, date: "2019-12-24", flair_after: "flairs/panda.png"},
                {name: "Firebolt8xp", amount: 5, date: "2019-12-30", flair_after: "skills/mining.png"},
                {name: "King Dumile", amount: 5, date: "2020-01-02", flair_after: "flairs/antisanta.png"},
                {name: "celastri", amount: 5, date: "2020-01-16"},
                {name: "Iron Zephrya", amount: 5, date: "2020-01-20"},
                {name: "Nereid", amount: 5, date: "2020-01-25"},
                {name: "PureF2pBlue", amount: 5, date: "2020-01-30"},
                {name: "Fwips", amount: 5, date: "2020-02-02", flair_after: "flairs/Yin_yang_amulet.png"},
                {name: "ironwind397", amount: 5, date: "2020-02-13"},
                {name: "thelast lvl", amount: 5, date: "2020-02-29", flair_after: "items/Iron_bar.gif"},
                {name: "Marrio III", amount: 5, date: "2020-02-29"},
                {name: "Iron Rwne", amount: 5, date: "2020-03-03", flair_after: "flairs/rwne.png"},
                {name: "Prof Zetlin", amount: 5, date: "2020-03-21", flair_after: "flairs/Shoulder_parrot.png"},
                {name: "R E3", amount: 5, date: "2020-03-24"},
                {name: "Plue", amount: 5, date: "2020-04-06", flair_after: "flairs/Snow_globe.png"},
                {name: "Solo Dancer", amount: 5, date: "2020-04-15", flair_after: "flairs/Redemption.png"},
                {name: "TheNutSlush", amount: 5, date: "2020-04-19", flair_after: "flairs/Reward_casket_beginner.png"},
                {name: "maddiefsna5", amount: 5, date: "2020-04-23", no_link: true},
                {name: "Ultw", amount: 5, date: "2020-04-28"},
                {name: "xxcxzx", amount: 5, date: "2020-05-05"},
                {name: "iTz a Loner", amount: 5, date: "2020-05-16", flair_after: "flairs/barricade.png"},
                {name: "Momoka Nishi", amount: 5, date: "2020-05-27", flair_after: "flairs/red_boater.png"},
                {name: "HCIM Keeper", amount: 5, date: "2020-05-31"},
                {name: "Covid 19 V2", amount: 5, date: "2020-06-10", flair_after: "flairs/virus.png"},
                {name: "Hierro Hero", amount: 5, date: "2020-06-17"},
                {name: "Raytheons", amount: 5, date: "2020-06-20"},
                {name: "Tohno1612", amount: ??, flair_after: "flairs/addy_helm.png"},
                {name: "H C Gilrix", amount: 2.5, date: "2018-03-04", flair_after: "flairs/HCIM.png"},
                {name: "Anonymous", amount: 2.5, date: "2018-07-26", no_link: true},
                {name: "Roavar", amount: 1.5, date: "2019-08-14", flair_after: "flairs/roavar.png"},
                {name: "ColdFingers1", amount: 1, date: "2019-01-15", flair_after: "flairs/ColdFingers1.png"},
                {name: "Anonymous", amount: 1, date: "2019-12-08", no_link: true},
                {name: "HCaliaszeven", amount: 1, date: "2020-01-22"},
                {name: "pussyexpert9", amount: 1, date: "2020-02-03"},
                {name: "5perm sock"},
                {name: "HC Yiffer"}, # pro bono tracking
                {name: "Disenthral"}, # pro bono tracking
                {name: "Jingle Bells", flair_after: "flairs/santa.png"}, # devs are allowed their own customizations
              ]

  def self.skills()
    SKILLS
  end

  def self.times()
    TIMES
  end

  def self.supporters_hashes()
    SUPPORTERS
  end

  def self.supporters()
    SUPPORTERS.map{|supporter| supporter[:name]}
  end

  def self.account_types
    ACCOUNT_TYPES
  end

  def self.account_type_ancestors
    ACCOUNT_TYPE_ANCESTORS
  end

  def self.sql_supporters()
    quoted_names = supporters.map{ |name| "'#{name}'" }
    "(#{quoted_names.join(",")})"
  end

  # The characters +, _, \s, -, %20 count as the same when doing a lookup on hiscores.
  def self.sanitize_name(str)
    if str.downcase == "_yrak"
      return str
    else
      str = ERB::Util.url_encode(str).gsub(/[-_\\+]|(%20)|(%C2%A0)/, " ")
      return str.gsub(/\A[^A-z0-9]+|[^A-z0-9\s\_-]+|[^A-z0-9]+\z/, "")
    end
  end

  def self.find_player(id)
    id = self.sanitize_name(id)
    splits = id.split(/[\s\_]|(%20)/)
    res = splits.join("_") # _ is a wildcard
    player = Player.where("lower(player_name) like '%#{res.downcase}%' and length(player_name) = length('#{res.downcase}')").first

    if player.nil?
      begin
        player = Player.find(Float(id))
      rescue
        return false
      end
    end
    return player
  end

  def url_friendly_player_name
    ERB::Util.url_encode(player_name).gsub(/(%C2)*%A0/, '_')
  end

  def hcim_dead?
    # Skip check for UIMs who can never have been HCIMs.
    return false if player_acc_type == 'UIM'

    Hiscores.hcim_dead?(player_name)
  end

  def calc_combat(stats_hash)
    att = stats_hash["attack_lvl"]
    str = stats_hash["strength_lvl"]
    defence = stats_hash["defence_lvl"]
    hp = stats_hash["hitpoints_lvl"]
    ranged = stats_hash["ranged_lvl"]
    magic = stats_hash["magic_lvl"]
    pray = stats_hash["prayer_lvl"]

    base = 0.25 * (defence + hp + (pray/2).floor)
    melee = 0.325 * (att + str)
	  range = 0.325 * ((ranged/2).floor + ranged)
	  mage = 0.325 * ((magic/2).floor + magic)
    combat = (base + [melee, range, mage].max).round(5)

    if combat < 3.4
      combat = 3.4
    end

    stats_hash["combat_lvl"] = combat
    return stats_hash
  end

  def get_ehp_type
    case player_acc_type
    when "Reg"
      ehp = F2POSRSRanks::Application.config.ehp_reg
    when "HCIM", "IM"
      ehp = F2POSRSRanks::Application.config.ehp_iron
    when "UIM"
      ehp = F2POSRSRanks::Application.config.ehp_uim
    end
  end

  def remove_cutoff(stats_hash)
    if stats_hash["overall_ehp"] < 1
      Player.where(player_name: player_name).destroy_all
      return true
    end
  end

  def update_player(stats: nil)
    if F2POSRSRanks::Application.config.downcase_fakes.include?(player_name.downcase)
      Player.where(player_name: player_name).destroy_all
    end
    Rails.logger.info "Updating #{player_name}"

    # Skip fetching from hiscores if stats are provided in parameters.
    unless stats
      begin
        stats, account_type = Hiscores
          .fetch_stats_by_acc(player_name, player_acc_type)
      rescue SocketError, Net::ReadTimeout
        Rails.logger.warn "#{player_name}'s hiscores retrieval failed"
        # Stats could not be fetched due to inresponsiveness (3 attempts).
        return false
      end

      unless stats
        if failed_updates.nil? or failed_updates < 1
          update_attributes(failed_updates: 1)
        else
          update_attributes(failed_updates: failed_updates + 1)
          update_attributes(potential_p2p: 1) if failed_updates > 10
        end
        return false
      end

      check_p2p_stats(stats)

      stats[:failed_updates] = 0

      # Temporarily disable auto account detection due to recent Jagex API outages
      # which result in false de-irons or other false account type changes.
      #
      # if player_acc_type != account_type
      #   stats[:player_acc_type] = account_type
      # elsif player_acc_type == 'HCIM' && account_type == 'HCIM' && hcim_dead?
      #   # Check if HCIM has died on the overall hiscores table.
      #   # Normally this should have been picked up by the `fetch_stats`
      #   # call, but this is sometimes not reliable.
      #   stats[:player_acc_type] = 'IM'
      # end
    end

    stats = calculate_virtual_stats(stats)
    stats[:updated_at] = Time.now

    self.attributes = stats
    self.save(validate: false)
  end

  def force_update_acc_type
    begin
      actual_stats, account_type = Hiscores.fetch_stats(player_name)
    rescue SocketError, Net::ReadTimeout
      Rails.logger.warn "#{player_name}'s hiscores retrieval failed"
      # Stats could not be fetched due to inresponsiveness (3 attempts).
      return false
    end

    return false unless account_type

    if player_acc_type != account_type
      if overall_xp_year_start
        ehp_diffs = get_gains_ehp_diffs()
        update_attribute(:player_acc_type, account_type)
        fix_wrong_acc_type_gains_and_records(actual_stats, ehp_diffs)
      else
        update_attribute(:player_acc_type, account_type)
      end
    elsif player_acc_type == 'HCIM' && account_type == 'HCIM' && hcim_dead?
      # Check if HCIM has died on the overall hiscores table.
      # Normally this should have been picked up by the `fetch_stats`
      # call, but this is sometimes not reliable.
      return update_attribute(:player_acc_type, 'IM')
    end

    true
  end

  def get_gains_ehp_diffs
    # gains and records are based on current EHP minus start EHP (day/week etc).
    # make sure that we save this difference, because changed acc type
    # will very likely result in different current EHP but not the start EHP.
    ehp_diffs = {}
    SKILLS.each do |skill|
      ehp = self.read_attribute("#{skill}_ehp")
      TIMES.each do |time|
        start_ehp = self.read_attribute("#{skill}_ehp_#{time}_start")
        ehp_diff = ehp - start_ehp
        ehp_diffs["#{skill}_ehp_#{time}"] = [ehp_diff, 0].max
      end
    end

    return ehp_diffs
  end

  def fix_wrong_acc_type_gains_and_records(actual_stats, ehp_diffs)
    # get the new current EHP after updating the player acc type
    stats = calculate_virtual_stats(actual_stats)

    # finally, set the correct #{SKILL}_ehp_#{TIME}_start so that gains and
    # records will display the correct, same amount as before the acc_type update
    fixed_ehps = {}
    SKILLS.each do |skill|
      ehp = stats["#{skill}_ehp"]
      fixed_ehps["#{skill}_ehp"] = ehp
      TIMES.each do |time|
        ehp_gain = ehp_diffs["#{skill}_ehp_#{time}"]
        fixed_ehps["#{skill}_ehp_#{time}_start"] = ehp - ehp_gain
      end
    end

    update_attributes(fixed_ehps)
  end

  def calculate_virtual_stats(stats)
    bonus_xp = calc_bonus_xps(stats)
    stats = calc_ehp(stats)
    stats = adjust_bonus_xp(stats, bonus_xp)

    stats = calc_combat(stats)

    stats["ttm_lvl"] = time_to_max(stats, "lvl")
    stats["ttm_xp"] = time_to_max(stats, "xp")

    if stats["overall_ehp"] > 250 or Player.supporters.include?(player_name)
      TIMES.each do |time|
        xp = self.read_attribute("overall_xp_#{time}_start")
        if xp.nil? or xp == 0
          stats = update_player_start_stats(time, stats)
        end
      end

      stats = check_record_gains(stats)
    end

    stats
  end

  def check_record_gains(stats_hash)
    SKILLS.each do |skill|
      xp = stats_hash["#{skill}_xp"] || self.read_attribute("#{skill}_xp")
      ehp = stats_hash["#{skill}_ehp"] || self.read_attribute("#{skill}_ehp")
      TIMES.each do |time|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_ehp = self.read_attribute("#{skill}_ehp_#{time}_start")
        max_xp = self.read_attribute("#{skill}_xp_#{time}_max")
        max_ehp = self.read_attribute("#{skill}_ehp_#{time}_max")
        if start_xp.nil? or start_ehp.nil?
          next
        end
        if max_xp.nil? or xp - start_xp > max_xp
          stats_hash["#{skill}_xp_#{time}_max"] = xp - start_xp
        end
        if max_ehp.nil? or ehp - start_ehp > max_ehp
          stats_hash["#{skill}_ehp_#{time}_max"] = ehp - start_ehp
        end
      end
    end

    return stats_hash
  end

  def update_player_start_stats(time, stats_hash)
    SKILLS.each do |skill|
      xp = stats_hash["#{skill}_xp"] || self.read_attribute("#{skill}_xp")
      ehp = stats_hash["#{skill}_ehp"] || self.read_attribute("#{skill}_ehp")
      stats_hash["#{skill}_xp_#{time}_start"] = xp
      stats_hash["#{skill}_ehp_#{time}_start"] = ehp
    end

    return stats_hash
  end

  def calc_skill_ehp(xp, tiers, xphrs)
    ehp = 0
    tiers.each.with_index do |tier, idx|
      tier = tier.to_f
      xphr = xphrs[idx].to_f
      if xphr != 0 and tier < xp
        if (idx+1) < tiers.length and xp >=  tiers[idx+1]
          ehp += (tiers[idx+1].to_f - tier)/xphr
        else
          ehp += (xp.to_f - tier)/xphr
        end
      end
    end
    return ehp
  end

  def calc_max_lvl_ehp(tiers, xphrs)
    return calc_skill_ehp(13034431, tiers, xphrs)
  end

  def calc_max_xp_ehp(tiers, xphrs)
    return calc_skill_ehp(200000000, tiers, xphrs)
  end

  def time_to_max(stats_hash, lvl_or_xp)
    ehp = get_ehp_type
    ttm = 0
    F2POSRSRanks::Application.config.skills.each do |skill|
      if skill != "p2p" and skill != "overall" and skill != "lms" and skill != "p2p_minigame" and skill != "clues_all" and skill != "clues_beginner" and skill != "obor_kc" and skill != "bryophyta_kc"
        skill_xp = stats_hash["#{skill}_xp"]
        if lvl_or_xp == "lvl" and skill_xp >= 13034431
          next
        elsif lvl_or_xp == "xp" and skill_xp == 200000000
          next
        end

        skill_ehp = stats_hash["#{skill}_ehp"]
        adjusted_skill_ehp = calc_skill_ehp(skill_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        if lvl_or_xp == "lvl"
          max_ehp = calc_max_lvl_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        else
          max_ehp = calc_max_xp_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        end

        max_ehp = (max_ehp*100).floor/100.0

        if max_ehp > adjusted_skill_ehp
          ttm += max_ehp - adjusted_skill_ehp
        end
      end
    end
    return ttm
  end

  def get_bonus_xp
    case player_acc_type
    when "Reg"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_reg
    when "HCIM", "IM"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_iron
    when "UIM"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_uim
    end
    return bonus_xp
  end

  # Returns hash in the following format.
  # "bonus_for": {bonus_from: expected_xp_in_bonus_for, bonus_from: xp, ...}
  # bonuses: {
  #   "prayer": {"attack": 123, "defence": 12, "strength": 12, ...},
  #   "smithing": {"crafting": 123456},
  #   ...
  # }
  def calc_bonus_xps(stats_hash)
    bonus_xps = get_bonus_xp
    bonuses = {}
    bonus_xps.each do |ratio, bonus_for, bonus_from, start_xp, end_xp|
      skill_from = stats_hash["#{bonus_from}_xp"]
      if skill_from <= start_xp.to_i
        next
      end

      bonus_xp = [([skill_from, end_xp].min - start_xp.to_i)*ratio.to_f, 200000000].min

      if bonuses[bonus_for] and bonuses[bonus_for][bonus_from]
        bonuses[bonus_for][bonus_from] += bonus_xp
      elsif bonuses[bonus_for]
        bonuses[bonus_for][bonus_from] = bonus_xp
      else
        bonuses[bonus_for] = {"#{bonus_from}" => bonus_xp}
      end
    end
    return bonuses
  end

  def calc_ehp(stats_hash)
    ehp = get_ehp_type
    total_ehp = 0.0
    total_lvl = 8
    total_xp = 0
    stats_list = F2POSRSRanks::Application.config.f2p_skills

    stats_list.each.with_index do |skill, skill_idx|
      skill_lvl = stats_hash["#{skill}_lvl"]
      skill_xp = stats_hash["#{skill}_xp"]

      skill_tiers = ehp["#{skill}_tiers"]
      skill_xphrs = ehp["#{skill}_xphrs"]
      skill_ehp = calc_tiered_ehp(skill_tiers, skill_xphrs, skill_xp)

      stats_hash["#{skill}_ehp"] = skill_ehp.round(2)
      total_ehp += skill_ehp.round(2)
      total_xp += skill_xp
      total_lvl += skill_lvl
    end

    stats_hash["overall_ehp"] = total_ehp.round(2)

    if stats_hash["overall_lvl"] < 34
      stats_hash["overall_lvl"] = total_lvl
      stats_hash["overall_xp"] = total_xp
    end

    return stats_hash
  end

  def adjust_bonus_xp(stats_hash, bonus_xp)
    ehp = get_ehp_type
    bonus_xp_list = get_bonus_xp
    bonus_xp.keys.each do |bonus_for|
      if bonus_for == "magic"
        next
      end

      skill_xp = stats_hash["#{bonus_for}_xp"]
      skill_ehp = stats_hash["#{bonus_for}_ehp"]
      skill_tiers = ehp["#{bonus_for}_tiers"]
      skill_xphrs = ehp["#{bonus_for}_xphrs"]
      actual_xp = skill_xp

      # get expected total bonus xp discrepancy
      bonus_xp[bonus_for].keys.each do |bonus_from|
        expected_xp = bonus_xp[bonus_for][bonus_from]
        actual_xp -= expected_xp
      end

      # calc ehp discrepancy
      if actual_xp < 0
        xp_discrepancy = -actual_xp
        if skill_xphrs == [0]
          if bonus_for == "firemaking"
            skill_xphrs = [144600]
            skill_ehp = skill_xp/144600
          elsif bonus_for == "cooking"
            skill_xphrs = [120000]
            skill_ehp = skill_xp/120000
          end
        end
        ehp_discrepancy = calc_skill_ehp(skill_xp + xp_discrepancy, skill_tiers, skill_xphrs) - skill_ehp
      else
        xp_discrepancy = 0
        ehp_discrepancy = 0
      end

      # subtract ehp discrepancy from the bonus_for skill if multiskill bonuses
      if bonus_xp[bonus_for].size > 1
        bonus_for_ehp = stats_hash["#{bonus_for}_ehp"]
        if bonus_for_ehp < ehp_discrepancy
          # puts "1 Subtracting #{ehp_discrepancy} ehp discrepancy and #{bonus_for_ehp} #{bonus_for} from overall_ehp."
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy - bonus_for_ehp).round(2)
          stats_hash["#{bonus_for}_ehp"] = 0
        else
          # puts "2 Subtracting #{ehp_discrepancy} from #{bonus_for} ehp."
          stats_hash["#{bonus_for}_ehp"] = (stats_hash["#{bonus_for}_ehp"] - ehp_discrepancy).round(2)
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
        end
      else
        bonus_from = bonus_xp[bonus_for].keys[0]
        bonus_from_ehp = stats_hash["#{bonus_from}_ehp"]
        if bonus_from_ehp < ehp_discrepancy
          # puts "3 Subtracting #{ehp_discrepancy} ehp discrepancy and #{bonus_from_ehp} #{bonus_from} from overall_ehp."
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy - bonus_from_ehp).round(2)
          stats_hash["#{bonus_from}_ehp"] = 0
        else
          # puts "4 Subtracting #{ehp_discrepancy} discrepancy from #{bonus_from} ehp."
          stats_hash["#{bonus_from}_ehp"] = (stats_hash["#{bonus_from}_ehp"] - ehp_discrepancy).round(2)
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
        end
      end
    end
    return stats_hash
  end

  def calc_tiered_ehp(skill_tiers, skill_xphrs, skill_xp)
    skill_ehp = 0.0
    skill_tiers.each.with_index do |skill_tier, tier_idx|
      skill_tier = skill_tier.to_f
      skill_xphr = skill_xphrs[tier_idx].to_f
      if skill_xphr != 0 and skill_tier < skill_xp
        if (tier_idx + 1) < skill_tiers.length and skill_xp >=  skill_tiers[tier_idx + 1]
          skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
        else
          skill_ehp += (skill_xp - skill_tier)/skill_xphr
        end
      end
    end
    return skill_ehp
  end

  def repair_tracking(time)
    xps = CML.fetch_exp(player_name, time)
    xp_start = {}

    SKILLS.each do |skill|
      xp_start = xp_start.merge({"#{skill}_xp_#{time}_start" => xps["#{skill}_xp"].to_i})
    end

    ehp = get_ehp_type
    ehp_start = {}
    (SKILLS - ["overall"]).each do |skill|
      skill_ehp = calc_skill_ehp(xps["#{skill}_xp"].to_i, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
      ehp_start = ehp_start.merge({"#{skill}_ehp_#{time}_start" => skill_ehp})
    end
    ehp_start["overall_ehp_#{time}_start"] = ehp_start.values.sum

    update_attributes(xp_start.merge(ehp_start))
    return xp_start, ehp_start
  end

  def repair_records
    recs = CML.fetch_records(player_name)
    return unless recs

    ehp = get_ehp_type
    ehp_recs = {}
    (TIMES - ["year"]).each do |time|
      time_recs = {}
      (SKILLS - ["overall"]).each do |skill|
        xp_gain = recs["#{skill}_xp_#{time}_max"].to_i
        curr_xp = self.read_attribute("#{skill}_xp")
        before_xp = curr_xp - xp_gain
        before_ehp = calc_skill_ehp(before_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        curr_ehp = calc_skill_ehp(curr_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        ehp_gain = (curr_ehp - before_ehp).round(2)
        time_recs = time_recs.merge({"#{skill}_ehp_#{time}_max" => ehp_gain})
      end
      ehp_recs = ehp_recs.merge(time_recs)
      ehp_recs["overall_ehp_#{time}_max"] = time_recs.values.max
    end

    recs_hash = recs.merge(ehp_recs)
    update_attributes(recs_hash)
    return recs_hash
  end

  def recalculate_ehp
    skill_hash = {}
    ehp = get_ehp_type
    TIMES.each do |time|
      start_stats_hash = {}
      SKILLS.each do |skill|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_stats_hash["#{skill}_xp"] = start_xp
        start_stats_hash["#{skill}_lvl"] = 1
      end
      bonus_xp = calc_bonus_xps(start_stats_hash)
      start_stats_hash = calc_ehp(start_stats_hash)
      start_stats_hash = adjust_bonus_xp(start_stats_hash, bonus_xp)

      SKILLS.each do |skill|
        skill_hash["#{skill}_ehp_#{time}_start"] = start_stats_hash["#{skill}_ehp"]
      end
    end
    update_attributes(skill_hash)
  end

  def check_p2p_stats(stats)
    actual_f2p_lvls = 0
    (SKILLS - ["overall"]).each do |skill|
      actual_f2p_lvls += stats["#{skill}_lvl"]
    end

    if stats["overall_lvl"] > 1493 or (stats["overall_lvl"] - 8) > actual_f2p_lvls
      update_attributes(:potential_p2p => 1)
    end
  end

  def self.initial_p2p_check(stats)
    return true if stats[:potential_p2p] > 0

    actual_f2p_lvls = 0
    (SKILLS - ["overall"]).each do |skill|
      actual_f2p_lvls += (stats["#{skill}_lvl"] or 0)
    end

    return true if (stats["overall_lvl"] - 8) > actual_f2p_lvls
    return false
  end

  def self.create_new(name)
    name = self.sanitize_name(name)
    is_found = self.find_player(name)

    if is_found
      return 'exists'
    elsif F2POSRSRanks::Application.config.downcase_fakes.include?(name.downcase)
      return 'p2p'
    end
    puts "not found"

    begin
      stats, account_type = Hiscores.fetch_stats(name)
    rescue SocketError, Net::ReadTimeout
      Rails.logger.warn "#{name}'s hiscores retrieval failed"
      # Stats could not be fetched due to inresponsiveness (3 attempts).
      return 'failed'
    end

    return unless stats  # Player does not exist if return value is nil

    return 'p2p' if initial_p2p_check(stats)

    name = Hiscores.get_registered_player_name(account_type, name)
    return unless name  # Player does not exist if return value is false

    player = Player.create!(player_name: name, player_acc_type: account_type)
    stats[:created_at] = Time.now
    player.update_player(stats: stats)
    player
  end

  def count_99
    count = 0

    (SKILLS - ["overall"]).each do |skill|
      count += 1 if self.read_attribute("#{skill}_lvl") >= 99
    end

    return count
  end

  def count_200m
    count = 0

    (SKILLS - ["overall"]).each do |skill|
      count += 1 if self.read_attribute("#{skill}_xp") >= 200000000
    end

    return count
  end

  def lowest_lvl
    skill_lvls = (SKILLS - ["overall"]).each.map { |skill| self.read_attribute("#{skill}_lvl").to_i }
    return skill_lvls.min
  end

  private

  def register_hcim_death
    self.hcim_has_died = true
    self.hcim_has_died_registered_at = DateTime.now
  end
end
