local AllianceBossS0Template = BaseClass("AllianceBossS0Template")

function AllianceBossS0Template:__init()
  self.id = nil
  self.difficulty = nil
  self.monsterId = nil
  self.name = nil
  self.donate_level = nil
  self.donateLevelExpList = nil
  self.donate_level_bouns = nil
  self.donateLevelDmgList = nil
  self.show_condition = nil
  self.unlock_condition = nil
  self.alliance_reward = nil
  self.alliance_bonus = nil
  self.reward = nil
  self.first_reward = nil
  self.background_image = nil
  self.monster_image = nil
  self.banner = nil
  self.isUnlock = nil
  self.personalDmg = nil
  self.personalReward = nil
  self.allianceDmg = nil
  self.allianceReward = nil
  self.personalMaxDmg = nil
  self.allianceMaxDmg = nil
  self.donateMaxLevel = nil
  self.building = nil
  self.monster_banner = nil
  self.record_banner = nil
  self.monster_prefab = nil
end

function AllianceBossS0Template:__delete()
  self.id = nil
  self.difficulty = nil
  self.monsterId = nil
  self.name = nil
  self.donate_level = nil
  self.donateLevelExpList = nil
  self.donate_level_bouns = nil
  self.donateLevelDmgList = nil
  self.show_condition = nil
  self.unlock_condition = nil
  self.alliance_reward = nil
  self.alliance_bonus = nil
  self.reward = nil
  self.first_reward = nil
  self.background_image = nil
  self.monster_image = nil
  self.banner = nil
  self.isUnlock = nil
  self.personalDmg = nil
  self.personalReward = nil
  self.allianceDmg = nil
  self.allianceReward = nil
  self.personalMaxDmg = nil
  self.allianceMaxDmg = nil
  self.donateMaxLevel = nil
  self.building = nil
  self.monster_banner = nil
  self.record_banner = nil
  self.monster_prefab = nil
end

function AllianceBossS0Template:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.difficulty = row:getValue("difficulty")
  self.monsterId = row:getValue("monsterId")
  self.name = row:getValue("name")
  self.donate_level = row:getValue("donate_level")
  self.donate_level_bouns = row:getValue("donate_level_bouns")
  self.show_condition = row:getValue("show_condition")
  local unlock_condition = row:getValue("unlock_condition")
  local level = 0
  local stage = 0
  if unlock_condition and 3 <= #unlock_condition then
    level = unlock_condition[2] or 0
    stage = unlock_condition[3] or 0
  end
  local conditions = {}
  conditions.level = level
  conditions.stage = stage
  self.unlock_condition = conditions
  self.alliance_reward = row:getValue("alliance_reward")
  self.alliance_bonus = row:getValue("alliance_bonus")
  self.allianceDmg, self.allianceReward, self.allianceMaxDmg = self:ParseDmgProgress(self.alliance_reward)
  self.reward = row:getValue("reward")
  self.personalDmg, self.personalReward, self.personalMaxDmg = self:ParseDmgProgress(self.reward)
  self.first_reward = row:getValue("first_reward")
  self.background_image = row:getValue("background_image")
  self.monster_image = row:getValue("monster_image")
  self.banner = row:getValue("banner")
  self.building = row:getValue("building")
  self.monster_banner = row:getValue("monster_banner")
  self.record_banner = row:getValue("record_banner")
  self.monster_prefab = row:getValue("monster_prefab")
end

function AllianceBossS0Template:ParseDmgProgress(dmgData)
  if dmgData then
    local dmgList = {}
    local rewardList = {}
    local dmg, reward, arr, dmgArr
    local max = 0
    for _, v in ipairs(dmgData) do
      arr = string.split(v, ";")
      if arr and #arr == 2 then
        dmg, reward = arr[1], arr[2]
        if dmg then
          dmgArr = string.split(dmg, ",")
          if dmgArr and #dmgArr == 2 then
            local dmgMin, dmgMax = tonumber(dmgArr[1]), tonumber(dmgArr[2])
            if max < dmgMin then
              max = dmgMin
            end
            dmgList[#dmgList + 1] = dmgMax
            rewardList[#rewardList + 1] = tonumber(reward)
          end
        end
      end
    end
    return dmgList, rewardList, max
  end
end

function AllianceBossS0Template:GetDonateMaxLevel()
  if self.donateLevelExpList == nil and self.donate_level then
    local arr, level, num
    local maxLevel = 0
    local result = {}
    for _, v in ipairs(self.donate_level) do
      if v then
        arr = string.split(v, ";")
        if arr and #arr == 2 then
          level = tonumber(arr[1])
          num = tonumber(arr[2])
          if maxLevel < level then
            maxLevel = level
          end
          result[#result + 1] = tonumber(num)
        end
      end
    end
    self.donateLevelExpList = result
    self.donateMaxLevel = maxLevel
  end
  return self.donateMaxLevel
end

function AllianceBossS0Template:GetDonateLevelExp(tarLevel)
  if self.donateLevelExpList == nil and self.donate_level then
    local arr, level, num
    local maxLevel = 0
    local result = {}
    for _, v in ipairs(self.donate_level) do
      if v then
        arr = string.split(v, ";")
        if arr and #arr == 2 then
          level = tonumber(arr[1])
          num = tonumber(arr[2])
          if maxLevel < level then
            maxLevel = level
          end
          result[#result + 1] = tonumber(num)
        end
      end
    end
    self.donateLevelExpList = result
    self.donateMaxLevel = maxLevel
  end
  if self.donateLevelExpList then
    return self.donateLevelExpList[tarLevel]
  end
end

function AllianceBossS0Template:GetDonateDmgAddition(level)
  if self.donateLevelDmgList == nil and self.donate_level_bouns then
    local arr, level, num
    local result = {}
    for _, v in ipairs(self.donate_level_bouns) do
      if v then
        arr = string.split(v, ";")
        if arr and #arr == 2 then
          level = tonumber(arr[1])
          num = tonumber(arr[2])
          result[level] = tonumber(num)
        end
      end
    end
    self.donateLevelDmgList = result
  end
  if self.donateLevelDmgList then
    return self.donateLevelDmgList[level]
  end
end

function AllianceBossS0Template:GetMaxStar()
  if self.allianceDmg then
    return #self.allianceDmg - 1
  end
end

return AllianceBossS0Template
