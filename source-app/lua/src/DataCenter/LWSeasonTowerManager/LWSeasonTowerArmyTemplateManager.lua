local LWSeasonTowerArmyTemplateManager = BaseClass("LWSeasonTowerArmyTemplateManager")
local LWSeasonTowerArmyTemplate = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerArmyTemplate")

local function __init(self)
  self.armyTemplateDic = {}
end

local function __delete(self)
  self.armyTemplateDic = nil
end

local function GetArmyTemplate(self, id)
  if self.armyTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.SEASON_TOWER_ARMY, tostring(id))
    if oneTemplate ~= nil then
      local item = LWSeasonTowerArmyTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.armyTemplateDic[item.id] = item
      end
    end
  end
  return self.armyTemplateDic[tonumber(id)]
end

local function TryGetArmyTemplate(self, id)
  if self.armyTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():tryGetLine(TableName.SEASON_TOWER_ARMY, tostring(id))
    if oneTemplate ~= nil then
      local item = LWSeasonTowerArmyTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.armyTemplateDic[item.id] = item
      end
    end
  end
  return self.armyTemplateDic[tonumber(id)]
end

function LWSeasonTowerArmyTemplateManager:GetSoldierDataList(armyId)
  local res = {}
  if checknumber(armyId) > 0 then
    local armyConfigData = self:TryGetArmyTemplate(checknumber(armyId))
    if not table.IsNullOrEmpty(armyConfigData.line_up) then
      local soldierDataListTmp = {}
      for k, v in pairs(armyConfigData.line_up) do
        if v.soldierData ~= nil then
          local soldierData = {
            count = v.soldierData.num,
            id = v.soldierData.metaId,
            lv = 0
          }
          local soldierConfigData = DataCenter.SoldierDataManager:GetTemplate(v.soldierData.metaId)
          if soldierConfigData ~= nil then
            soldierData.lv = soldierConfigData.lv
          end
          if soldierDataListTmp[tostring(soldierData.id)] ~= nil then
            soldierDataListTmp[tostring(soldierData.id)].count = soldierDataListTmp[tostring(soldierData.id)].count + soldierData.count
          else
            soldierDataListTmp[tostring(soldierData.id)] = soldierData
          end
        end
      end
      for i, v in pairs(soldierDataListTmp) do
        table.insert(res, v)
      end
    end
  end
  return res
end

function LWSeasonTowerArmyTemplateManager:GetInterpolationTemplate(armyInfo, nextArmyInfo, floor)
  local oneTemplate = LocalController:instance():tryGetLine(TableName.SEASON_TOWER_ARMY, tostring(armyInfo.armyId))
  if oneTemplate == nil then
    return
  end
  local item = LWSeasonTowerArmyTemplate.New()
  item:InitData(oneTemplate)
  if nextArmyInfo.floor > armyInfo.floor then
    local nextTemplate = self:GetArmyTemplate(tostring(nextArmyInfo.armyId))
    if nextTemplate ~= nil then
      item:InterpolationByTemplate(nextTemplate, floor - armyInfo.floor, nextArmyInfo.floor - armyInfo.floor)
    end
  end
  return item
end

LWSeasonTowerArmyTemplateManager.__init = __init
LWSeasonTowerArmyTemplateManager.__delete = __delete
LWSeasonTowerArmyTemplateManager.GetArmyTemplate = GetArmyTemplate
LWSeasonTowerArmyTemplateManager.TryGetArmyTemplate = TryGetArmyTemplate
return LWSeasonTowerArmyTemplateManager
