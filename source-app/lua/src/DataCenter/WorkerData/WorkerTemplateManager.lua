local WorkerTemplateManager = BaseClass("WorkerTemplateManager")
local WorkerTemplate = require("DataCenter.WorkerData.WorkerTemplate")

local function __init(self)
  self.templateShowDic = nil
  self.buildingWorkerDic = nil
  self.initAll = false
  self.showWorkerList = nil
end

local function __delete(self)
  self.templateShowDic = nil
  self.buildingWorkerDic = nil
  self.initAll = nil
  self.showWorkerList = nil
end

local function InitLineData(self, lineData, isShow)
  local id = lineData.id
  if self.templateShowDic and self.templateShowDic[id] then
    return
  end
  local item = WorkerTemplate.New()
  item:InitData(lineData)
  if not self.templateShowDic then
    self.templateShowDic = {}
  end
  self.templateShowDic[id] = item
  if item.isShow == 1 then
    if not self.showWorkerList then
      self.showWorkerList = {}
    end
    self.showWorkerList[id] = item
    if not self.buildingWorkerDic then
      self.buildingWorkerDic = {}
    end
    for i = 1, #item.workingBuildList do
      local itemId = item.workingBuildList[i]
      if not self.buildingWorkerDic[itemId] then
        self.buildingWorkerDic[itemId] = {}
      end
      self.buildingWorkerDic[itemId][#self.buildingWorkerDic[itemId] + 1] = item
    end
  end
end

local function InitAllTemplate(self)
  if not self.templateShowDic then
    self.templateShowDic = {}
  end
  LocalController:instance():visitTable(TableName.LW_Worker, function(id, lineData)
    InitLineData(self, lineData)
  end)
  self.initAll = true
end

local function GetAllShowTemplate(self)
  if not self.initAll then
    self:InitAllTemplate()
  end
  return self.showWorkerList
end

local function GetShowTemplateById(self, id)
  local template = self:GetTemplateById(id)
  if template then
    return template
  end
  return nil
end

local function GetTemplateById(self, id)
  if self.templateShowDic and self.templateShowDic[id] then
    return self.templateShowDic[id]
  end
  local line = LocalController:instance():getLine(TableName.LW_Worker, tonumber(id))
  if line then
    InitLineData(self, line)
  end
  return self.templateShowDic[id]
end

local function GetAllWorkerForBuild(self, itemId)
  if not self.initAll then
    self:InitAllTemplate()
  end
  return self.buildingWorkerDic[itemId]
end

local function GetWorkerQualityById(self, id)
  local template = self:GetTemplateById(id)
  if template then
    return template.quality
  end
  return 0
end

WorkerTemplateManager.__init = __init
WorkerTemplateManager.__delete = __delete
WorkerTemplateManager.InitAllTemplate = InitAllTemplate
WorkerTemplateManager.GetAllShowTemplate = GetAllShowTemplate
WorkerTemplateManager.GetShowTemplateById = GetShowTemplateById
WorkerTemplateManager.GetTemplateById = GetTemplateById
WorkerTemplateManager.GetAllWorkerForBuild = GetAllWorkerForBuild
WorkerTemplateManager.GetWorkerQualityById = GetWorkerQualityById
return WorkerTemplateManager
