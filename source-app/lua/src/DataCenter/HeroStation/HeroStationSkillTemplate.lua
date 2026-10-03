local HeroStationSkillTemplate = BaseClass("HeroStationSkillTemplate")
local Localization = CS.GameEntry.Localization
local USABLE_SKILLS = {
  1000,
  3000,
  3001
}

local function __init(self)
  self.id = 0
  self.stationId = 0
  self.building = 0
  self.condition = {}
  self.name = ""
  self.description = ""
  self.description_value = ""
  self.description_unlock = ""
  self.unlock_tips = ""
  self.unlock_value = ""
  self.effect_description = ""
  self.icon = ""
  self.para = ""
  self.effect_type = 0
  self.effect = 0
  self.effect_k = {}
  self.effect_c = {}
  self.effect_para = {}
  self.usable = false
end

local function __delete(self)
  self.id = nil
  self.stationId = nil
  self.building = nil
  self.condition = nil
  self.name = nil
  self.description = nil
  self.description_value = nil
  self.description_unlock = nil
  self.unlock_tips = nil
  self.unlock_value = nil
  self.effect_description = nil
  self.icon = nil
  self.para = nil
  self.effect_type = nil
  self.effect = nil
  self.effect_k = nil
  self.effect_c = nil
  self.effect_para = nil
  self.usable = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.stationId = tonumber(row:getValue("station_id")) or 0
  self.building = tonumber(row:getValue("building")) or 0
  self.condition = {}
  local condition = row:getValue("condition")
  if not string.IsNullOrEmpty(condition) then
    local conditionPairs = string.split(condition, "|")
    for _, conditionPair in ipairs(conditionPairs) do
      local spl = string.split(conditionPair, ";")
      if #spl == 2 then
        local c = {
          quality = tonumber(spl[1]),
          count = tonumber(spl[2])
        }
        table.insert(self.condition, c)
      else
        Logger.LogError("table 'hero_station' error: condition pair")
      end
    end
  end
  self.name = tostring(row:getValue("name")) or ""
  self.description = tostring(row:getValue("description")) or ""
  self.description_value = tostring(row:getValue("description_value")) or ""
  self.description_unlock = tostring(row:getValue("description_unlock")) or ""
  self.unlock_tips = tostring(row:getValue("unlock_tips")) or ""
  self.unlock_value = tostring(row:getValue("unlock_value")) or ""
  self.effect_description = tostring(row:getValue("effect_description")) or ""
  self.icon = tostring(row:getValue("icon")) or ""
  self.para = tostring(row:getValue("para")) or ""
  self.effect_type = tonumber(row:getValue("effect_type")) or 0
  self.effect = tonumber(row:getValue("effect")) or 0
  self.effect_k = {}
  self.effect_c = {}
  local effectValue = row:getValue("effect_value")
  if not string.IsNullOrEmpty(effectValue) then
    local values = string.split(effectValue, ";")
    for _, value in ipairs(values) do
      if string.contains(value, ",") then
        local cs = string.split(value, ",")
        for _, c in ipairs(cs) do
          table.insert(self.effect_c, tonumber(c))
        end
      else
        table.insert(self.effect_k, tonumber(value))
      end
    end
  end
  self.effect_para = {}
  local effectPara = row:getValue("effect_para")
  if not string.IsNullOrEmpty(effectPara) then
    local values = string.split(effectPara, ";")
    for _, value in ipairs(values) do
      table.insert(self.effect_para, tonumber(value))
    end
  end
  self.usable = table.hasvalue(USABLE_SKILLS, self.id)
end

local function GetDescription(self, heroUuidList)
  local descriptionList = {}
  local descs = string.split(self.description, "|")
  local descValues = string.split(self.description_value, "|")
  for i = 1, table.count(descs) do
    if descValues[i] ~= nil then
      local values
      if self.id == 1000 then
        local val1 = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(self.id))
        local qualitySum, levelSum = 0, 0
        for _, heroUuid in pairs(heroUuidList) do
          local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
          qualitySum = qualitySum + heroData.quality
          levelSum = levelSum + heroData.level
        end
        local val2 = math.max(math.ceil(self.effect_para[1] * #heroUuidList * math.max(qualitySum / self.effect_para[2], 1) * math.log(levelSum, 10)), 1)
        values = {val1, val2}
      elseif self.id == 1001 then
        local val = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(self.id))
        values = {val}
      elseif self.id == 1002 then
        local val = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(self.id))
        values = {val}
      elseif self.id == 1003 then
        local val1 = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(self.id))
        local val2 = "???"
        values = {val1, val2}
      else
        values = string.split(descValues[i], ";")
      end
      descriptionList[i] = Localization:GetString(descs[i], table.unpack(values))
    else
      descriptionList[i] = Localization:GetString(descs[i])
    end
  end
  return descriptionList
end

local function GetDescriptionUnlock(self)
  local descriptionUnlockList = {}
  local descUnlocks = string.split(self.description_unlock, "|")
  for i = 1, table.count(descUnlocks) do
    descriptionUnlockList[i] = Localization:GetString(descUnlocks[i])
  end
  return descriptionUnlockList
end

local function GetUnlockTips(self)
  local unlockTipsList = {}
  local unlockTips = string.split(self.unlock_tips, "|")
  local unlockValues = string.split(self.unlock_value, "|")
  for i = 1, table.count(unlockTips) do
    if unlockValues[i] ~= nil then
      local values = string.split(unlockValues[i], ";")
      unlockTipsList[i] = Localization:GetString(unlockTips[i], table.unpack(values))
    else
      unlockTipsList[i] = Localization:GetString(unlockTips[i])
    end
  end
  return unlockTipsList
end

local function GetEffectDescription(self)
  local effectDescriptionList = {}
  local effectDescs = string.split(self.effect_description, "|")
  for i = 1, table.count(effectDescs) do
    effectDescriptionList[i] = Localization:GetString(effectDescs[i])
  end
  return effectDescriptionList
end

HeroStationSkillTemplate.__init = __init
HeroStationSkillTemplate.__delete = __delete
HeroStationSkillTemplate.InitData = InitData
HeroStationSkillTemplate.GetDescription = GetDescription
HeroStationSkillTemplate.GetDescriptionUnlock = GetDescriptionUnlock
HeroStationSkillTemplate.GetUnlockTips = GetUnlockTips
HeroStationSkillTemplate.GetEffectDescription = GetEffectDescription
return HeroStationSkillTemplate
