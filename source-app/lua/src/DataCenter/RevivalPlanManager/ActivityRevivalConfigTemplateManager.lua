local ActivityRevivalConfigTemplateManager = BaseClass("ActivityRevivalConfigTemplateManager")
local ActivityRevivalConfigTemplate = require("DataCenter/RevivalPlanManager/ActivityRevivalConfigTemplate")

function ActivityRevivalConfigTemplateManager:__init()
  self.templateDic = nil
  self.templateFlagDic = nil
end

function ActivityRevivalConfigTemplateManager:__delete()
  self.templateDic = nil
  self.templateFlagDic = nil
end

function ActivityRevivalConfigTemplateManager:GetTemplate(stageId)
  if self.templateFlagDic == nil then
    self.templateFlagDic = {}
    self.templateDic = {}
  end
  if self.templateFlagDic[stageId] then
    return self.templateDic[stageId]
  end
  self.templateFlagDic[stageId] = true
  local rowData = LocalController:instance():getLine(TableName.ACTIVITY_REVIVAL_CONFIG, stageId)
  if rowData == nil then
    return nil
  end
  local item = ActivityRevivalConfigTemplate.New()
  item:UpdateData(rowData)
  self.templateDic[stageId] = item
  return item
end

return ActivityRevivalConfigTemplateManager
