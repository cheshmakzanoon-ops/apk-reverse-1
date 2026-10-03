local GatherResourceTemplateManager = BaseClass("GatherResourceTemplateManager")

local function __init(self)
  self.templateDic = {}
  self.maxLevel = 0
  self.maxLevelByType = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetTemplate(self, id)
  if self.templateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.GatherResource, tostring(id))
    if oneTemplate ~= nil then
      local item = GatherResourceTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[tonumber(item.id)] = item
      end
    end
  end
  return self.templateDic[tonumber(id)]
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.GatherResource, function(id, lineData)
    local item = GatherResourceTemplate.New()
    item:InitData(lineData)
    if item.id ~= nil then
      self.templateDic[tonumber(item.id)] = item
    end
  end)
end

local function GetMaxLevel(self)
  if self.maxLevel > 0 then
    return self.maxLevel
  end
  local result = 0
  for k, v in pairs(self.templateDic) do
    if result < v.level then
      result = v.level
    end
  end
  self.maxLevel = result
  return result
end

local function GetMaxLevelbyType(self, type)
  local infoList = DataCenter.SeasonDataManager.SpecialServerSeasonInfoList
  if infoList then
    local serverId = LuaEntry.Player:GetCurServerId()
    local data = infoList[toInt(serverId)]
    if data and data.seasonConfigId then
      local seasonConfig = LocalController:instance():getLine(TableName.LW_Season, data.seasonConfigId)
      if seasonConfig.world_resource_search and #seasonConfig.world_resource_search == 2 then
        if SeasonUtil.CurServerIsInSeason() then
          return toInt(seasonConfig.world_resource_search[1])
        else
          return toInt(seasonConfig.world_resource_search[2])
        end
      end
    end
  end
  return 10
end

local function GetTemplatebyLevelType(self, level, type, specialType)
  for k, v in pairs(self.templateDic) do
    if v.resource_type == type and v.type == specialType and v.level == level then
      return v
    end
  end
end

GatherResourceTemplateManager.__init = __init
GatherResourceTemplateManager.__delete = __delete
GatherResourceTemplateManager.GetTemplate = GetTemplate
GatherResourceTemplateManager.InitAllTemplate = InitAllTemplate
GatherResourceTemplateManager.GetMaxLevel = GetMaxLevel
GatherResourceTemplateManager.GetMaxLevelbyType = GetMaxLevelbyType
GatherResourceTemplateManager.GetTemplatebyLevelType = GetTemplatebyLevelType
return GatherResourceTemplateManager
