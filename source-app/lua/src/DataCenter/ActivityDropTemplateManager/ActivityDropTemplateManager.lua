local ActivityDropTemplateManager = BaseClass("ActivityDropTemplateManager")
local ActivityDropTemplate = require("DataCenter.ActivityDropTemplateManager.ActivityDropTemplate")

local function __init(self)
  self.templateDict = {}
  self.activityDict = {}
  self.dropIdDict = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDict = nil
  self.activityDict = nil
  self.dropIdDict = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Activity_Drop, function(id, lineData)
    local template = ActivityDropTemplate.New()
    template:InitData(lineData)
    local dropId = tonumber(lineData.drop_id)
    self.templateDict[tonumber(id)] = template
    if self.activityDict[template.activity] == nil then
      self.activityDict[template.activity] = {}
    end
    table.insert(self.activityDict[template.activity], template)
    if self.dropIdDict[dropId] == nil then
      self.dropIdDict[dropId] = {}
    end
    table.insert(self.dropIdDict[dropId], template)
  end)
end

local function GetTemplatesByActId(self, actId)
  local templates = {}
  if not actId then
    return templates
  end
  local _actId = tonumber(actId)
  if self.activityDict[_actId] then
    templates = self.activityDict[_actId]
    table.sort(templates, function(a, b)
      return a.order > b.order
    end)
  end
  return templates
end

local function GetTemplatesByDropId(self, dropId)
  local templates = {}
  if not dropId then
    return templates
  end
  local _actId = tonumber(dropId)
  if self.dropIdDict[_actId] then
    templates = self.dropIdDict[_actId]
    table.sort(templates, function(a, b)
      return a.order > b.order
    end)
  end
  return templates
end

local function GetDropTemplateById(self, id)
  if not self.templateDict then
    return nil
  end
  return self.templateDict[id]
end

ActivityDropTemplateManager.__init = __init
ActivityDropTemplateManager.__delete = __delete
ActivityDropTemplateManager.InitAllTemplate = InitAllTemplate
ActivityDropTemplateManager.GetTemplatesByActId = GetTemplatesByActId
ActivityDropTemplateManager.GetTemplatesByDropId = GetTemplatesByDropId
ActivityDropTemplateManager.GetDropTemplateById = GetDropTemplateById
return ActivityDropTemplateManager
