local ActivityRevivalScoreShowTemplateManager = BaseClass("ActivityRevivalScoreShowTemplateManager")
local ActivityRevivalScoreShowTemplate = require("DataCenter/RevivalPlanManager/ActivityRevivalScoreShowTemplate")

function ActivityRevivalScoreShowTemplateManager:__init()
  self.templateDic = nil
  self.templateFlagDic = nil
end

function ActivityRevivalScoreShowTemplateManager:__delete()
  self.templateDic = nil
  self.templateFlagDic = nil
end

function ActivityRevivalScoreShowTemplateManager:GetTemplate(id)
  if self.templateFlagDic == nil then
    self.templateFlagDic = {}
    self.templateDic = {}
  end
  if self.templateFlagDic[id] then
    return self.templateDic[id]
  end
  self.templateFlagDic[id] = true
  local rowData = LocalController:instance():getLine(TableName.ACTIVITY_REVIVAL_SCORE_SHOW, id)
  if rowData == nil then
    return nil
  end
  local item = ActivityRevivalScoreShowTemplate.New()
  item:UpdateData(rowData)
  self.templateDic[id] = item
  return item
end

return ActivityRevivalScoreShowTemplateManager
