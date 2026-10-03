local AllianceScienceTemplateManager = BaseClass("AllianceScienceTemplateManager")
local AllianceScienceTabTemplate = require("DataCenter.AllianceScienceTemplateManager.AllianceScienceTabTemplate")
local AllianceScienceTemplate = require("DataCenter.AllianceScienceTemplateManager.AllianceScienceTemplate")

function AllianceScienceTemplateManager:__init()
  self.alScienceTabTemplateDic = nil
  self.alScienceTemplateDic = {}
  self.buffDic = nil
end

function AllianceScienceTemplateManager:__delete()
  self.alScienceTabTemplateDic = nil
  self.alScienceTemplateDic = nil
  self.alScienceInfoTemplateDic = nil
  self.buffDic = nil
end

function AllianceScienceTemplateManager:GetAlScienceTabTemplate(tab, season_group)
  if self.alScienceTabTemplateDic == nil or self.alScienceTabTemplateDic[tab] == nil then
    self:TransAllAlScienceTabTemplate()
  end
  local dataList = self.alScienceTabTemplateDic[tab]
  if tab == 3 then
    if season_group == nil then
      local season = DataCenter.SeasonDataManager:GetSeason() or 0
      if season and 0 < season then
        local config = DataCenter.SeasonDataManager:GetSeasonConfig()
        if config and config.alliance_science and config.alliance_science ~= "" and config.alliance_science ~= 0 then
          season_group = config.alliance_science
        end
      end
    end
    if season_group ~= nil and season_group ~= "" and season_group ~= 0 then
      local n_season_group = toInt(season_group)
      local theSeasonTabData = {}
      for k, v in ipairs(dataList) do
        if v and v.season_group == n_season_group then
          table.insert(theSeasonTabData, v)
        end
      end
      return theSeasonTabData
    end
    return {}
  end
  return dataList
end

function AllianceScienceTemplateManager:GetAlScienceTemplateByBuffId(buffId)
  if self.buffDic == nil then
    self.buffDic = {}
    LocalController:instance():visitTable(TableName.AlScience, function(id, line)
      local item = AllianceScienceTemplate.New()
      item:InitData(line)
      if item.id ~= nil then
        self.alScienceTemplateDic[item.id] = item
      end
      if item.level == 0 then
        self.buffDic[item.effectKey] = item
      end
    end)
  end
  if self.buffDic == nil then
    return nil
  end
  return self.buffDic[toInt(buffId)]
end

function AllianceScienceTemplateManager:GetAlScienceInfo(science_id)
  local idNum = toInt(science_id)
  if self.alScienceTabTemplateDic == nil or self.alScienceInfoTemplateDic == nil then
    self:TransAllAlScienceTabTemplate()
  end
  if self.alScienceInfoTemplateDic then
    return self.alScienceInfoTemplateDic[idNum]
  end
  return nil
end

function AllianceScienceTemplateManager:GetAlScienceTemplate(id)
  local idNum = toInt(id)
  if self.alScienceTemplateDic[idNum] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.AlScience, tostring(id))
    if oneTemplate ~= nil then
      local item = AllianceScienceTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.alScienceTemplateDic[item.id] = item
      end
    end
  end
  return self.alScienceTemplateDic[idNum]
end

function AllianceScienceTemplateManager:TransAllAlScienceTabTemplate()
  self.alScienceTabTemplateDic = {}
  self.alScienceInfoTemplateDic = {}
  LocalController:instance():visitTable(TableName.AlScienceTab, function(id, lineData)
    local item = AllianceScienceTabTemplate.New()
    item:InitData(lineData)
    if item.tab ~= nil then
      if self.alScienceTabTemplateDic[item.tab] == nil then
        self.alScienceTabTemplateDic[item.tab] = {}
      end
      self.alScienceInfoTemplateDic[item.id] = item
      table.insert(self.alScienceTabTemplateDic[item.tab], item)
    end
  end)
end

function AllianceScienceTemplateManager:ExistSeasonScienceTabData(season_group)
  local dataList = self:GetAlScienceTabTemplate(3, season_group)
  if dataList ~= nil and 0 < #dataList then
    return true
  end
  return false
end

return AllianceScienceTemplateManager
