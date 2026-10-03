local CampScienceTemplateManager = BaseClass("CampScienceTemplateManager")
local CampScienceTabTemplate = require("DataCenter.CampScience.CampScienceTabTemplate")
local CampScienceDetailTemplate = require("DataCenter.CampScience.CampScienceDetailTemplate")
local SeasonCampBuffTemplate = require("DataCenter.CampScience.SeasonCampBuffTemplate")

function CampScienceTemplateManager:__init()
  self.campScienceTabTemplateDic = nil
  self.campScienceGroup = nil
  self.campScienceDetailDic = nil
  self.campSeasonBuffDic = nil
end

function CampScienceTemplateManager:__delete()
  self.campScienceTabTemplateDic = nil
  self.campScienceGroup = nil
  self.campScienceDetailDic = nil
  self.campSeasonBuffDic = nil
end

function CampScienceTemplateManager:GetCampScienceTabTemplate(tabId, campId)
  self.campScienceTabTemplateDic = self.campScienceTabTemplateDic or {}
  self.campScienceTabTemplateDic[tabId] = self.campScienceTabTemplateDic[tabId] or {}
  local tabCampScienceList = self.campScienceTabTemplateDic[tabId]
  local campScienceList = tabCampScienceList[campId]
  if campScienceList == nil then
    campScienceList = self:GetCampScienceTabTemplatesByCampID(tabId, campId)
    tabCampScienceList[campId] = campScienceList
  end
  return campScienceList
end

function CampScienceTemplateManager:GetCampScienceTabTemplatesByCampID(tabId, campId)
  local campTabList = {}
  LocalController:instance():visitTable(TableName.LW_CAMP_SCIENCE_TAB, function(id, lineData)
    if lineData.season_group == tabId and lineData.camp == tostring(campId) then
      local item = CampScienceTabTemplate.New()
      item:InitData(lineData)
      table.insert(campTabList, item)
    end
  end)
  return campTabList
end

function CampScienceTemplateManager:GetCampScienceGroup(id)
  self.campScienceGroup = self.campScienceGroup or {}
  if self.campScienceGroup[id] == nil then
    self.campScienceGroup[id] = LocalController:instance():getLine(TableName.LW_CAMP_SCIENCE_GROUP, tostring(id))
  end
  return self.campScienceGroup[id]
end

function CampScienceTemplateManager:GeCampScienceDetailTemplate(id)
  local idNum = toInt(id)
  self.campScienceDetailDic = self.campScienceDetailDic or {}
  local detailTemplate = self.campScienceDetailDic[idNum]
  if detailTemplate == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_CAMP_SCIENCE_DETAIL, tostring(id))
    if oneTemplate ~= nil then
      detailTemplate = CampScienceDetailTemplate.New()
      detailTemplate:InitData(oneTemplate)
      if detailTemplate.id ~= nil then
        self.campScienceDetailDic[detailTemplate.id] = detailTemplate
      end
    end
  end
  return detailTemplate
end

function CampScienceTemplateManager:GetCampBuffTemplatesByCampID(tabId, campId)
  local campBuffList = {}
  LocalController:instance():visitTable(TableName.SEASON_CAMP_BUFF, function(id, lineData)
    if lineData ~= nil and lineData.season_group == tabId and lineData.camp == tostring(campId) then
      local item = SeasonCampBuffTemplate.New()
      item:UpdateData(lineData)
      table.insert(campBuffList, item)
    end
  end)
  return campBuffList
end

function CampScienceTemplateManager:GetCampBuffTemplatesByID(id)
  self.campSeasonBuffDic = self.campSeasonBuffDic or {}
  local campBuffTemplate = self.campSeasonBuffDic[id]
  if campBuffTemplate == nil then
    local lineData = LocalController:instance():getLine(TableName.SEASON_CAMP_BUFF, id)
    campBuffTemplate = SeasonCampBuffTemplate.New()
    campBuffTemplate:UpdateData(lineData)
    self.campSeasonBuffDic[id] = campBuffTemplate
  end
  return campBuffTemplate
end

return CampScienceTemplateManager
