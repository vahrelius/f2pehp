require 'open-uri'

class CML
  extend Base
  CML_BASE_URL = 'https://crystalmathlabs.com/tracker/api.php'

  class << self
    def fetch_records(player_name)
      uri = records_api_url(player_name)
      records = fetch(uri)
      parse_records(records)
    end

    def fetch_exp(player_name, time_back)
      now = DateTime.now

      deltatime =
        case time_back
        when 'year'
          now - DateTime.new(now.year, 1, 1)
        when 'month'
          now - DateTime.new(now.year, now.month, 1)
        else
          raise ArgumentError, "time_back must be either 'year' or 'month'"
        end

      uri = datapoints_api_url(player_name, "#{deltatime.to_i}d")
      records = fetch(uri)
      parse_exp(records)
    end

    private

    def records_api_url(player_name)
      URI.join(
        CML_BASE_URL,
        "?type=recordsofplayer&player=#{player_name}"
      )
    end

    def datapoints_api_url(player_name, time)
      URI.join(
        CML_BASE_URL,
        "?type=datapoints&player=#{player_name}&time=#{time}"
      )
    end

    def parse_records(records)
      return unless records
      extracted_records = {}

      skills = F2POSRSRanks::Application.config.skills
      player_skills = Player.skills

      records.split("\n").each.with_index do |record, idx|
        skill = skills[idx]

        if player_skills.include?(skill)
          skill_records = record.split(',')
          extracted_records.merge!(
            "#{skill}_xp_day_max" => skill_records[0],
            "#{skill}_xp_week_max" => skill_records[2],
            "#{skill}_xp_month_max" => skill_records[4]
          )
        end
      end

      extracted_records
    end

    def parse_exp(records)
      return unless records
      records = records.split(',')
      { 'overall_xp'     => xps[0],
        'attack_xp'      => xps[1],
        'defence_xp'     => xps[2],
        'strength_xp'    => xps[3],
        'hitpoints_xp'   => xps[4],
        'ranged_xp'      => xps[5],
        'prayer_xp'      => xps[6],
        'magic_xp'       => xps[7],
        'cooking_xp'     => xps[8],
        'woodcutting_xp' => xps[9],
        'fishing_xp'     => xps[11],
        'firemaking_xp'  => xps[12],
        'crafting_xp'    => xps[13],
        'smithing_xp'    => xps[14],
        'mining_xp'      => xps[15],
        'runecraft_xp'   => xps[21] }
    end
  end
end
