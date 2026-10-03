local ParkourScoreTierTemplate = BaseClass("ParkourScoreTierTemplate")

function ParkourScoreTierTemplate:__init()
  self.id = nil
  self.tier = nil
  self.exp = nil
  self.exp_reward = nil
  self.icon = nil
  self.rewardInfo = nil
  self.tier_name = nil
  self.big_icon_bg = nil
  self.icon_effect = nil
  self.sound_id = nil
end

function ParkourScoreTierTemplate:__delete()
  self.id = nil
  self.tier = nil
  self.exp = nil
  self.exp_reward = nil
  self.icon = nil
  self.rewardList = nil
  self.tier_name = nil
  self.big_icon_bg = nil
  self.icon_effect = nil
  self.sound_id = nil
end

function ParkourScoreTierTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.tier = row:getValue("tier")
  self.exp = row:getValue("exp")
  self.exp_reward = row:getValue("exp_reward")
  self.rewardList = self:ParseRewardString(self.exp_reward)
  self.icon = row:getValue("icon")
  self.tier_name = row:getValue("tier_name")
  self.big_icon_bg = row:getValue("big_icon_bg")
  self.icon_effect = row:getValue("icon_effect")
  self.sound_id = row:getValue("sound_id")
end

function ParkourScoreTierTemplate:ParseRewardString(str)
  local result = {}
  if not str or str == "" then
    return result
  end
  for entry in string.gmatch(str, "([^|]+)") do
    local parts = {}
    for part in string.gmatch(entry, "([^;]+)") do
      table.insert(parts, part)
    end
    if 3 <= #parts then
      table.insert(result, {
        id = tonumber(parts[1]),
        exp = tonumber(parts[2]),
        rewardId = tonumber(parts[3])
      })
    end
  end
  return result
end

return ParkourScoreTierTemplate
