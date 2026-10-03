local ComicTemplateManager = BaseClass("ComicTemplateManager")
local ComicTemplate = require("DataCenter.Comic.ComicTemplate")
local ComicGroupTemplate = require("DataCenter.Comic.ComicGroupTemplate")

local function __init(self)
  self.comicIdMap = {}
  self.groupMap = {}
  self.typeMap = {}
  self:InitGroupMap()
end

local function __delete(self)
  self.comicIdMap = nil
  self.groupMap = nil
  self.typeMap = nil
end

local function InitGroupMap(self)
  LocalController:instance():visitTable(TableName.LW_Comic, function(id, lineData)
    local item = ComicTemplate.New()
    item:InitData(lineData)
    if self.comicIdMap[item.id] == nil then
      self.comicIdMap[item.id] = item
    end
  end)
  LocalController:instance():visitTable(TableName.LW_Comic_Group, function(id, lineData)
    local item = ComicGroupTemplate.New()
    item:InitData(lineData)
    if self.groupMap[item.id] == nil then
      self.groupMap[item.id] = item
    end
    if self.typeMap[item.open_type] == nil then
      self.typeMap[item.open_type] = {}
    end
    table.insert(self.typeMap[item.open_type], item.id)
  end)
end

local function GetTemplate(self, id)
  return self.comicIdMap[id]
end

local function GetGroupTemplate(self, id)
  return self.groupMap[id]
end

local function GetComicIdListByGroupId(self, groupId)
  if self.groupMap[groupId] then
    return self.groupMap[groupId].comicListId
  end
end

local function GetGroupIdByTypeAndParam(self, type, param)
  local ret = {}
  if self.typeMap[type] then
    local map = self.typeMap[type]
    for k, v in ipairs(map) do
      local groupTemplate = self:GetGroupTemplate(v)
      local meetFlag = false
      if type == EComicShowType.GameSeason then
        if param[1] == groupTemplate.para[1] and param[2] >= groupTemplate.para[2] then
          meetFlag = true
        end
      elseif param == groupTemplate.para[1] then
        meetFlag = true
      end
      if meetFlag then
        table.insert(ret, v)
      end
    end
  end
  return ret
end

ComicTemplateManager.__init = __init
ComicTemplateManager.__delete = __delete
ComicTemplateManager.GetTemplate = GetTemplate
ComicTemplateManager.GetGroupTemplate = GetGroupTemplate
ComicTemplateManager.GetComicIdListByGroupId = GetComicIdListByGroupId
ComicTemplateManager.InitGroupMap = InitGroupMap
ComicTemplateManager.GetGroupIdByTypeAndParam = GetGroupIdByTypeAndParam
return ComicTemplateManager
