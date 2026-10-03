local BuildQueueTemplateManager = BaseClass("BuildQueueTemplateManager")

local function __init(self)
  self.buildQueueTemplateDic = {}
  self.queueSortList = {}
end

local function __delete(self)
  self.buildQueueTemplateDic = nil
  self.queueSortList = nil
end

local function InitRobotTableList(self)
  self.buildQueueTemplateDic = {}
  self.queueSortList = {}
  local sortList = {}
  LocalController:instance():visitTable(TableName.LWBuildQueue, function(id, lineData)
    local item = BuildQueueTemplate.New()
    item:InitData(lineData)
    if item.id ~= nil and item.id ~= 0 then
      table.insert(sortList, item)
      self.buildQueueTemplateDic[item.id] = item
    end
  end)
  table.sort(sortList, function(a, b)
    return a.order < b.order
  end)
  for i = 1, #sortList do
    table.insert(self.queueSortList, sortList[i].id)
  end
end

local function GetBuildQueueTemplate(self, id)
  if not self.buildQueueTemplateDic[tonumber(id)] then
    local item = BuildQueueTemplate.New()
    item:InitData(LocalController:instance():getLine(TableName.LWBuildQueue, id))
    self.buildQueueTemplateDic[item.id] = item
  end
  return self.buildQueueTemplateDic[tonumber(id)]
end

local function GetBuildQueueIdByIndex(self, order)
  return self.queueSortList[order]
end

local function IsSeasonRobotByIndex(self, order)
  local id = self:GetBuildQueueIdByIndex(order)
  if id == nil then
    return false
  end
  local template = self:GetBuildQueueTemplate(id)
  if template == nil then
    return false
  end
  return template.isWorld
end

BuildQueueTemplateManager.__init = __init
BuildQueueTemplateManager.__delete = __delete
BuildQueueTemplateManager.GetBuildQueueTemplate = GetBuildQueueTemplate
BuildQueueTemplateManager.GetBuildQueueIdByIndex = GetBuildQueueIdByIndex
BuildQueueTemplateManager.InitRobotTableList = InitRobotTableList
BuildQueueTemplateManager.IsSeasonRobotByIndex = IsSeasonRobotByIndex
return BuildQueueTemplateManager
