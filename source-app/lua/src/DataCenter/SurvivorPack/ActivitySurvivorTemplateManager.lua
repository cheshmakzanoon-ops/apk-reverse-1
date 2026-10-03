local ActivitySurvivorTemplateManager = BaseClass("ActivitySurvivorTemplateManager")
local ActivitySurvivorTemplate = require("DataCenter.SurvivorPack.ActivitySurvivorTemplate")

function ActivitySurvivorTemplateManager:__init()
  self.templateDic = nil
end

function ActivitySurvivorTemplateManager:__delete()
  self.templateDic = nil
end

function ActivitySurvivorTemplateManager:InitTemplate()
  if self.templateDic ~= nil then
    return
  end
  self.templateDic = {}
  LocalController:instance():visitTable(TableName.ACTIVITY_SURVIVOR, function(id, lineData)
    local template = ActivitySurvivorTemplate.New(lineData)
    self.templateDic[tostring(id)] = template
  end)
end

function ActivitySurvivorTemplateManager:GetTemplate(id)
  self:InitTemplate()
  if id == nil or self.templateDic == nil then
    return nil
  end
  return self.templateDic[tostring(id)]
end

function ActivitySurvivorTemplateManager:GetAllTemplate()
  self:InitTemplate()
  return self.templateDic or {}
end

return ActivitySurvivorTemplateManager
