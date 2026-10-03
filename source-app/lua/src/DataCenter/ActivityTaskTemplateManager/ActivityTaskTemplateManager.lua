local ActivityTaskTemplateManager = BaseClass("ActivityTaskTemplateManager")

local function __init(self)
  self.taskTemplateDic = {}
  self.taskTemplateTypeDic = {}
  self.bnTaskTemplateDic = {}
end

local function __delete(self)
  self.taskTemplateDic = nil
  self.taskTemplateTypeDic = nil
  self.bnTaskTemplateDic = nil
end

local function GetActTaskTemplate(self, id)
  local numId = tonumber(id)
  if self.taskTemplateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.ActivityTaskXml, tostring(id))
    if oneTemplate ~= nil then
      local item = ActivityTaskTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.taskTemplateDic[item.id] = item
      end
    end
  end
  return self.taskTemplateDic[numId]
end

function ActivityTaskTemplateManager:GetBNTaskTemplate(id)
  local numId = tonumber(id)
  if self.bnTaskTemplateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.BN_ActivityTaskXml, tostring(id))
    if oneTemplate ~= nil then
      local item = ActivityTaskTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.bnTaskTemplateDic[item.id] = item
      end
    end
  end
  return self.bnTaskTemplateDic[numId]
end

local function GetActTaskTemplateByType(self, task_type)
  if self.taskTemplateTypeDic == nil then
    self.taskTemplateTypeDic = {}
  end
  local task_type_int = toInt(task_type)
  local taskList = self.taskTemplateTypeDic[task_type_int]
  if taskList ~= nil then
    return taskList
  end
  taskList = {}
  LocalController:instance():visitTable(TableName.ActivityTaskXml, function(_, lineData)
    if lineData and lineData.task_type and toInt(lineData.task_type) == task_type_int then
      local item = ActivityTaskTemplate.New()
      item:InitData(lineData)
      table.insert(taskList, item)
    end
  end)
  if #taskList ~= 0 then
    self.taskTemplateTypeDic[task_type_int] = taskList
  end
  return taskList
end

ActivityTaskTemplateManager.__init = __init
ActivityTaskTemplateManager.__delete = __delete
ActivityTaskTemplateManager.GetActTaskTemplate = GetActTaskTemplate
ActivityTaskTemplateManager.GetActTaskTemplateByType = GetActTaskTemplateByType
return ActivityTaskTemplateManager
