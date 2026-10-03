local LWZombieRushTemplateManager = BaseClass("LWZombieRushTemplateManager")
local LWZombieRushTemplate = require("DataCenter.LWZombieRush.LWZombieRushTemplate")

function LWZombieRushTemplateManager:__init()
  self.templateDict = {}
  self.zombieRushType2TemplateIdDict = {}
  self.season = nil
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
end

function LWZombieRushTemplateManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  self.templateDict = nil
  self.zombieRushType2TemplateIdDict = nil
  self.season = nil
end

function LWZombieRushTemplateManager:GetTemplate(templateId)
  if self.templateDict[templateId] == nil then
    local lineData = LocalController:instance():getLine(TableName.LWZombieRush, templateId)
    if lineData == nil then
      Logger.LogError("LWZombieRushTemplateManager GetTemplate lineData is nil id:" .. tostring(templateId))
      return nil
    end
    local template = LWZombieRushTemplate.New()
    template:Init(lineData)
    self.templateDict[template.id] = template
  end
  return self.templateDict[templateId]
end

function LWZombieRushTemplateManager:GetAllTemplateIdsByType(zombieRushType)
  if self.zombieRushType2TemplateIdDict[zombieRushType] == nil then
    self.zombieRushType2TemplateIdDict[zombieRushType] = {}
    LocalController:instance():visitTable(TableName.LWZombieRush, function(id, lineData)
      if tonumber(lineData.type) == zombieRushType and self:CheckShowOpenCondition(lineData.season_condition) then
        table.insert(self.zombieRushType2TemplateIdDict[zombieRushType], id)
      end
    end)
  end
  return self.zombieRushType2TemplateIdDict[zombieRushType]
end

function LWZombieRushTemplateManager:CheckShowOpenCondition(season_condition)
  if string.IsNullOrEmpty(season_condition) then
    return true
  end
  local arr = string.split(season_condition, ";")
  if arr and 2 <= #arr then
    local season = arr[1] and tonumber(arr[1]) or 0
    local seasonDays = arr[2] and tonumber(arr[2]) or 0
    return season < self.season or self.season == season and seasonDays <= self:GetSeasonDays()
  end
  return true
end

local function GetSeason(self)
  self.season = DataCenter.SeasonDataManager:GetSeason()
  return self.season
end

local function GetSeasonDays(self)
  local _, seasonDays = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  return seasonDays
end

local function OnPassDay()
  DataCenter.LWZombieRushTemplateManager.zombieRushType2TemplateIdDict = {}
  EventManager:GetInstance():Broadcast(EventId.ZombieRushPassDayRefresh)
end

LWZombieRushTemplateManager.getters.season = GetSeason
LWZombieRushTemplateManager.GetSeasonDays = GetSeasonDays
LWZombieRushTemplateManager.OnPassDay = OnPassDay
return LWZombieRushTemplateManager
