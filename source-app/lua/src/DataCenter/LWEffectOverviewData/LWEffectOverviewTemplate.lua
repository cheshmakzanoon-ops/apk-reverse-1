local LWEffectOverviewTemplate = BaseClass("LWEffectOverviewTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.effectId = 0
  self.effectSource = 0
  self.heroList = {}
  self.index = 0
  self.effectSourceList = {}
  self.effectSource2EffectIds = {}
  self.armyType = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.effectId = nil
  self.effectSource = nil
  self.heroList = nil
  self.index = 0
  self.effectSourceList = nil
  self.effectSource2EffectIds = nil
  self.armyType = 0
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name") or ""
  self.effectId = tonumber(row:getValue("effect_id")) or 0
  self.effectSource = tonumber(row:getValue("effect_source"), 2) or 0
  self.armyType = tonumber(row:getValue("army_type")) or 0
  local hero_list = row:getValue("hero_list") or ""
  table.clear(self.heroList)
  if not string.IsNullOrEmpty(hero_list) then
    local heroIdArray = string.split(hero_list, "|")
    for i = 1, #heroIdArray do
      local heroId = tonumber(heroIdArray[i])
      table.insert(self.heroList, heroId)
    end
  end
  self.index = tonumber(row:getValue("index")) or 0
  local sum_list = row:getValue("sum_list") or ""
  if not string.IsNullOrEmpty(sum_list) then
    local effectSourceArray = string.split(sum_list, "|")
    for i = 1, #effectSourceArray do
      local sourceType = tonumber(effectSourceArray[i])
      table.insert(self.effectSourceList, sourceType)
    end
  end
  local sum_effect = row:getValue("sum_effect") or ""
  if not string.IsNullOrEmpty(sum_effect) then
    local effectIdGroupArray = string.split(sum_effect, "|")
    if table.count(effectIdGroupArray) == table.count(self.effectSourceList) then
      for i = 1, table.count(effectIdGroupArray) do
        local effectSourceType = self.effectSourceList[i]
        local effectIds = {}
        local effectIdArray = string.split(effectIdGroupArray[i], ";")
        for j = 1, table.count(effectIdArray) do
          table.insert(effectIds, tonumber(effectIdArray[j]))
        end
        self.effectSource2EffectIds[effectSourceType] = effectIds
      end
    end
  end
end

local function GetEffectIdListByEffectSourceType(self, effectOverviewSourcePoint)
  if self.effectSource2EffectIds[effectOverviewSourcePoint] then
    return self.effectSource2EffectIds[effectOverviewSourcePoint]
  end
  return nil
end

local function IsHeroSkillSourceOpen(self)
  local result = self.effectSource & EffectOverviewSourcePoint.HeroSkill
  return 0 < result
end

local function IsAllianceTechSourceOpen(self)
  local result = self.effectSource & EffectOverviewSourcePoint.AllianceTech
  return 0 < result
end

local function IsTechSourceOpen(self)
  local result = self.effectSource & EffectOverviewSourcePoint.Tech
  return 0 < result
end

local function IsBuildingSourceOpen(self)
  local result = self.effectSource & EffectOverviewSourcePoint.Building
  return 0 < result
end

LWEffectOverviewTemplate.__init = __init
LWEffectOverviewTemplate.__delete = __delete
LWEffectOverviewTemplate.InitData = InitData
LWEffectOverviewTemplate.IsHeroSkillSourceOpen = IsHeroSkillSourceOpen
LWEffectOverviewTemplate.IsAllianceTechSourceOpen = IsAllianceTechSourceOpen
LWEffectOverviewTemplate.IsTechSourceOpen = IsTechSourceOpen
LWEffectOverviewTemplate.IsBuildingSourceOpen = IsBuildingSourceOpen
LWEffectOverviewTemplate.GetEffectIdListByEffectSourceType = GetEffectIdListByEffectSourceType
return LWEffectOverviewTemplate
