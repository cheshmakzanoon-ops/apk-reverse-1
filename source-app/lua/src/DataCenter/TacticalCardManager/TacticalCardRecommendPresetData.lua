local TacticalCardRecommendPresetData = BaseClass("TacticalCardRecommendPresetData")
local TacticalCardGroupData = require("DataCenter.TacticalCardManager.TacticalCardGroupData")

local function __init(self)
  self.isInit = false
end

local function __delete(self)
  self.isInit = nil
end

function TacticalCardRecommendPresetData:Init()
  self.isInit = true
  self.allCardGroupList = {}
  local curTmpDataList = self:GetCurSeasonQuickEquipStyleTypes()
  if not curTmpDataList then
    return
  end
  for _, v in ipairs(curTmpDataList) do
    local cardGroupData = TacticalCardGroupData.New()
    cardGroupData:UpdateDataFromTemplate(v)
    table.insert(self.allCardGroupList, cardGroupData)
  end
end

function TacticalCardRecommendPresetData:GetAllCardGroupDataList()
  if not self.isInit then
    self:Init()
  end
  self:Init()
  return self.allCardGroupList
end

function TacticalCardRecommendPresetData:GetCurSeasonQuickEquipStyleTypes()
  self:InitQuickEquipStyleTypes()
  local season = DataCenter.SeasonDataManager:GetSeason()
  if not self.quickEquipStyleTypes[season] then
    return {}
  end
  return self.quickEquipStyleTypes[season]
end

function TacticalCardRecommendPresetData:InitQuickEquipStyleTypes()
  if self.quickEquipStyleTypes then
    return
  end
  self.quickEquipStyleTypes = {}
  LocalController:instance():visitTable(TableName.TacticalCardRecommendSeason, function(id, lineData)
    local id = lineData:getValue("id")
    local season = lineData:getValue("season")
    local sort = lineData:getValue("sort")
    local sort_name = lineData:getValue("sort_name") or ""
    local recommend_cardId_list = lineData:getValue("recommend_card") or {}
    if not self.quickEquipStyleTypes[season] then
      self.quickEquipStyleTypes[season] = {}
    end
    table.insert(self.quickEquipStyleTypes[season], {
      id = id,
      sort = sort,
      sort_name = sort_name,
      cardIds = recommend_cardId_list
    })
  end)
  for season, v in pairs(self.quickEquipStyleTypes) do
    table.sort(v, function(a, b)
      if a.sort ~= b.sort then
        return a.sort < b.sort
      end
      return a.id < b.id
    end)
  end
end

function TacticalCardRecommendPresetData:GetAllPresetDataList()
  self:Init()
  return self.allCardGroupList or {}
end

function TacticalCardRecommendPresetData:GetCustomCardGroupByIndex(index)
  if not self.isInit then
    self:InitData()
  end
  return self.allCardGroupList and self.allCardGroupList[index]
end

TacticalCardRecommendPresetData.__init = __init
TacticalCardRecommendPresetData.__delete = __delete
return TacticalCardRecommendPresetData
