local TacticalCardSlotDataManager = BaseClass("TacticalCardSlotDataManager")
local BattleCardSlotTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardSlotTemplate")
local TacticalCardSlotData = require("DataCenter.TacticalCardManager.TacticalCardSlotData")

local function __init(self)
  self.slotDataDic = {}
  self.slotTemplateDic = {}
end

local function __delete(self)
  self.slotDataDic = nil
  self.slotTemplateDic = nil
end

function TacticalCardSlotDataManager:GetAllSlotDataList(masteryId, season)
  local ret = {}
  local allTmpData = self:GetAllSlotTemplateList(masteryId, season)
  for _, v in pairs(allTmpData) do
    local slotId = v.slot_id
    local slotData = self:GetSlotDataBySlotId(masteryId, season, slotId)
    table.insert(ret, slotData)
  end
  return ret
end

function TacticalCardSlotDataManager:GetSlotDataBySlotId(masteryId, season, slotId)
  local masteryDic = self.slotDataDic[masteryId]
  if not masteryDic then
    masteryDic = {}
    self.slotDataDic[masteryId] = masteryDic
  end
  local seasonDic = masteryDic[season]
  if not seasonDic then
    seasonDic = {}
    masteryDic[season] = seasonDic
  end
  local slotData = seasonDic[slotId]
  if not slotData then
    local tmpData = self:GetSlotTemplateData(masteryId, season, slotId)
    slotData = TacticalCardSlotData.New()
    slotData:InitData(tmpData)
    seasonDic[slotId] = slotData
  end
  return slotData
end

function TacticalCardSlotDataManager:GetAllSlotTemplateList(masteryId, season)
  if not table.containsKey(self.slotTemplateDic, masteryId) then
    self:CollectData(masteryId, season)
  end
  local seasonDic = self.slotTemplateDic[masteryId]
  if not seasonDic then
    return {}
  end
  return seasonDic[season] or {}
end

function TacticalCardSlotDataManager:GetSlotTemplateData(masteryId, season, slotId)
  if not table.containsKey(self.slotTemplateDic, masteryId) then
    self:CollectData(masteryId, season)
  end
  local seasonDic = self.slotTemplateDic[masteryId]
  if not seasonDic or not seasonDic[season] then
    Logger.LogError(string.format("not find config! masteryId:%s season:%s", masteryId, season))
    return {}
  end
  return seasonDic[season][slotId]
end

function TacticalCardSlotDataManager:CollectData(masteryId, season)
  if not masteryId or not season then
    Logger.LogError("params is null!")
    return
  end
  LocalController:instance():visitTable(TableName.TacticalCardSlot, function(id, lineData)
    local dataMasteryId = lineData:getIntValue("mastery")
    local dataSeasonId = lineData:getIntValue("season")
    if dataMasteryId ~= masteryId or dataSeasonId ~= season then
      return
    end
    local slotTemplate = BattleCardSlotTemplate.New()
    slotTemplate:UpdateData(lineData)
    local masterySlotDic = self.slotTemplateDic[dataMasteryId]
    if not masterySlotDic then
      masterySlotDic = {}
      self.slotTemplateDic[masteryId] = masterySlotDic
    end
    local seasonSlotDic = masterySlotDic[season]
    if not seasonSlotDic then
      seasonSlotDic = {}
      masterySlotDic[season] = seasonSlotDic
    end
    local slotId = slotTemplate.slot_id
    seasonSlotDic[slotId] = slotTemplate
  end)
end

TacticalCardSlotDataManager.__init = __init
TacticalCardSlotDataManager.__delete = __delete
return TacticalCardSlotDataManager
