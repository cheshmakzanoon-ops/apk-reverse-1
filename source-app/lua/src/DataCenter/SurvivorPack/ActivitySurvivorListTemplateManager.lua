local ActivitySurvivorListTemplateManager = BaseClass("ActivitySurvivorListTemplateManager")
local ActivitySurvivorListTemplate = require("DataCenter.SurvivorPack.ActivitySurvivorListTemplate")

function ActivitySurvivorListTemplateManager:__init()
  self.templateDic = nil
  self.templateList = nil
end

function ActivitySurvivorListTemplateManager:__delete()
  self.templateDic = nil
  self.templateList = nil
end

function ActivitySurvivorListTemplateManager:InitTemplate()
  if self.templateDic ~= nil then
    return
  end
  self.templateDic = {}
  self.templateList = {}
  LocalController:instance():visitTable(TableName.ACTIVITY_SURVIVOR_LIST, function(rowId, lineData)
    local template = ActivitySurvivorListTemplate.New(lineData)
    local templateId = template.id
    if templateId == nil or templateId == 0 or templateId == "" then
      templateId = rowId
      template.id = rowId
    end
    table.insert(self.templateList, template)
    local idKey = tostring(templateId or "")
    if idKey == "" then
      return
    end
    local groupKey = tostring(template.group or "")
    self.templateDic[idKey] = self.templateDic[idKey] or {}
    self.templateDic[idKey][groupKey] = template
  end)
end

function ActivitySurvivorListTemplateManager:GetTemplate(id, group)
  self:InitTemplate()
  if id == nil or self.templateDic == nil then
    return nil
  end
  local idKey = tostring(id)
  local groupKey = tostring(group or "")
  local groupDic = self.templateDic[idKey]
  if groupDic == nil then
    return nil
  end
  return groupDic[groupKey]
end

function ActivitySurvivorListTemplateManager:ForEachTemplate(callback)
  self:InitTemplate()
  if callback == nil then
    return
  end
  for _, tpl in ipairs(self.templateList or {}) do
    if tpl ~= nil then
      callback(tpl.id, tpl)
    end
  end
end

function ActivitySurvivorListTemplateManager:GetAllTemplate()
  self:InitTemplate()
  local ret = {}
  for idKey, groupDic in pairs(self.templateDic or {}) do
    for _, tpl in pairs(groupDic) do
      ret[idKey] = tpl
    end
  end
  return ret
end

return ActivitySurvivorListTemplateManager
