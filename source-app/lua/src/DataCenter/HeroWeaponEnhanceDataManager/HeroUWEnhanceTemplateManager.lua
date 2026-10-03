local HeroUWEnhanceTemplateManager = BaseClass("HeroUWEnhanceTemplateManager", CEventable)
local Localization = _G.CS.GameEntry.Localization
local HeroUniqueWeaponTemplate = require("DataCenter.HeroUniqueWeaponDataManager.HeroUniqueWeaponTemplate")
local HeroUWEnhanceLvTemplate = require("DataCenter.HeroWeaponEnhanceDataManager.HeroUWEnhanceLvTemplate")

local function __init(self)
  self.lvTemplateDict = {}
  self.costTemplateDict = {}
end

local function __delete(self)
  self.lvTemplateDict = nil
end

function HeroUWEnhanceTemplateManager:GetHeroUWUnitTemplate(heroId, type)
  local id = heroId * 100 + type
  if self.lvTemplateDict[id] then
    return self.lvTemplateDict[id]
  end
  local rowData = LocalController:instance():getLine(TableName.LW_UW_ENHANCE_LV, id)
  if not rowData then
    return nil
  end
  local template = HeroUWEnhanceLvTemplate.New()
  template:InitData(rowData)
  self.lvTemplateDict[id] = template
  return template
end

function HeroUWEnhanceTemplateManager:GetUpgradeInfo(type, level)
  local costId = type * 100000 + level
  if self.costTemplateDict[costId] then
    return self.costTemplateDict[costId]
  end
  local rowData = LocalController:instance():getLine(TableName.LW_UW_ENHANCE_COST, costId)
  if not rowData then
    return nil
  end
  local id = tonumber(rowData:getValue("id")) or 0
  local type = tonumber(rowData:getValue("type")) or 0
  local lv = tonumber(rowData:getValue("lv")) or 0
  local cost = tonumber(rowData:getValue("cost")) or 0
  local unitCondition = rowData:getValue("unit_condition") or {}
  local sortedCondition = {}
  for type, level in pairs(unitCondition) do
    table.insert(sortedCondition, {type = type, level = level})
  end
  table.sort(sortedCondition, function(a, b)
    return a.level < b.level
  end)
  self.costTemplateDict[costId] = {
    id = id,
    type = type,
    lv = lv,
    cost = cost,
    unitCondition = sortedCondition
  }
  return self.costTemplateDict[costId]
end

function HeroUWEnhanceTemplateManager:GetMaxLevel(heroId, type)
  local template = self:GetHeroUWUnitTemplate(heroId, type)
  return template and template.maxLv or 0
end

function HeroUWEnhanceTemplateManager:GetCurrentLevelAttr(heroId, type, level)
  local template = self:GetHeroUWUnitTemplate(heroId, type)
  if not template then
    return 0, 0
  end
  local allAttr, allValue = template:GetAllValueAtLv(level)
  local selfAttr, selfValue = template:GetSelfValueAtLv(level)
  return allAttr, allValue, selfAttr, selfValue
end

function HeroUWEnhanceTemplateManager:GetNextUnlockSelfAttr(heroId, type, level)
  local template = self:GetHeroUWUnitTemplate(heroId, type)
  if not template then
    return 0, 0
  end
  return template:GetNextUnlockSelfAttr(level)
end

HeroUWEnhanceTemplateManager.__init = __init
HeroUWEnhanceTemplateManager.__delete = __delete
return HeroUWEnhanceTemplateManager
