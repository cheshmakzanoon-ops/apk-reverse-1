local AdvancedChallengeBossTemplate = BaseClass("AdvancedChallengeBossTemplate")

function AdvancedChallengeBossTemplate:__init()
  self.id = nil
  self.world_monster = nil
  self.building_name = nil
  self.preview_time = nil
  self.challenge_time = nil
  self.count_down_hour = nil
  self.attack_skill_id = nil
  self.attack_interval = nil
  self.crazy_skill_id = nil
  self.crazy_attack_interval = nil
  self.crazy_time = nil
  self.boss_put_model = nil
  self.progress_score_icon = nil
  self.player_progress = nil
  self.player_reward = nil
  self.player_progress_special_s = nil
  self.player_reward_show = nil
  self.player_progress_special = nil
  self.alliance_progress = nil
  self.alliance_reward = nil
  self.alliance_progress_special_s = nil
  self.alliance_reward_show = nil
  self.alliance_progress_special = nil
  self.box_reward = nil
  self.boxReward = nil
  self.box_reward_new = nil
  self.box_reward_sure = nil
  self.boxRewardSure = nil
  self.advanced_challenge_banner_ui = nil
  self.advanced_challenge_box_ui = nil
  self.advanced_challenge_effect_ui_env = nil
  self.box_reward_show = nil
  self.chat_icon = nil
end

function AdvancedChallengeBossTemplate:__delete()
  self.id = nil
  self.world_monster = nil
  self.building_name = nil
  self.preview_time = nil
  self.challenge_time = nil
  self.count_down_hour = nil
  self.attack_skill_id = nil
  self.attack_interval = nil
  self.crazy_skill_id = nil
  self.crazy_attack_interval = nil
  self.crazy_time = nil
  self.boss_put_model = nil
  self.progress_score_icon = nil
  self.player_progress = nil
  self.player_reward = nil
  self.player_progress_special_s = nil
  self.player_reward_show = nil
  self.player_progress_special = nil
  self.alliance_progress = nil
  self.alliance_reward = nil
  self.alliance_progress_special_s = nil
  self.alliance_reward_show = nil
  self.alliance_progress_special = nil
  self.box_reward = nil
  self.box_reward_new = nil
  self.box_reward_sure = nil
  self.boxRewardSure = nil
  self.advanced_challenge_banner_ui = nil
  self.advanced_challenge_box_ui = nil
  self.advanced_challenge_effect_ui_env = nil
  self.box_reward_show = nil
  self.chat_icon = nil
end

function AdvancedChallengeBossTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.world_monster = row:getValue("world_monster") or 0
  self.building_name = row:getValue("building_name")
  self.preview_time = row:getValue("preview_time")
  self.challenge_time = row:getValue("challenge_time")
  self.count_down_hour = row:getValue("count_down_hour")
  self.attack_skill_id = row:getValue("attack_skill_id")
  self.attack_interval = row:getValue("attack_interval")
  self.crazy_skill_id = row:getValue("crazy_skill_id")
  self.crazy_attack_interval = row:getValue("crazy_attack_interval")
  self.crazy_time = row:getValue("crazy_time")
  self.boss_put_model = row:getValue("boss_put_model")
  self.progress_score_icon = row:getValue("progress_score_icon")
  self.player_progress = row:getValue("player_progress")
  self.player_reward = row:getValue("player_reward")
  self.player_progress_special_s = row:getValue("player_progress_special_s")
  self.player_reward_show = row:getValue("player_reward_show")
  self.player_progress_special = row:getValue("player_progress_special")
  self.alliance_progress = row:getValue("alliance_progress")
  self.alliance_reward = row:getValue("alliance_reward")
  self.alliance_progress_special_s = row:getValue("alliance_progress_special_s")
  self.alliance_reward_show = row:getValue("alliance_reward_show")
  self.alliance_progress_special = row:getValue("alliance_progress_special")
  self.box_reward = row:getValue("box_reward")
  self.box_reward_new = row:getValue("box_reward_new")
  self.box_reward_sure = row:getValue("box_reward_sure")
  self.advanced_challenge_banner_ui = row:getValue("advanced_challenge_banner_ui")
  self.advanced_challenge_box_ui = row:getValue("advanced_challenge_box_ui")
  self.advanced_challenge_effect_ui_env = row:getValue("advanced_challenge_effect_ui_env")
  self.box_reward_show = row:getValue("box_reward_show")
  self.chat_icon = row:getValue("chat_icon")
end

function AdvancedChallengeBossTemplate:GetBoxRewardSure()
  if self.boxRewardSure == nil and self.box_reward_sure then
    local groupArr = string.split(self.box_reward_sure, ";")
    if groupArr and 0 < #groupArr then
      self.boxRewardSure = {}
      local index = 0
      for _, v in ipairs(groupArr) do
        if v then
          local arr = string.split(v, "|")
          if arr and #arr == 3 then
            index = index + 1
            self.boxRewardSure[index] = {
              tonumber(arr[1]),
              tonumber(arr[2]),
              tonumber(arr[3])
            }
          end
        end
      end
    end
  end
  return self.boxRewardSure
end

function AdvancedChallengeBossTemplate:GetBoxReward()
  if self.boxReward == nil and self.box_reward then
    local split1 = string.split(self.box_reward, ";")
    if split1 and 0 < #split1 then
      self.boxReward = {}
      local index = 0
      for _, v in ipairs(split1) do
        local split2 = string.split(v, "|")
        if 2 < #split2 then
          index = index + 1
          local quality = tonumber(split2[1])
          local rate = tonumber(split2[2])
          local rewardId = tonumber(split2[3])
          self.boxReward[index] = {
            quality = quality,
            rate = rate,
            rewardId = rewardId
          }
        end
      end
    end
  end
  return self.boxReward
end

return AdvancedChallengeBossTemplate
