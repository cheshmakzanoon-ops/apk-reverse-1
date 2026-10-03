local LWActivityAlarmClockTemplateManager = BaseClass("LWActivityAlarmClockTemplateManager")
local LWActivityAlarmClockTemplate = require("DataCenter.LWActivityAlarmClock.LWActivityAlarmClockTemplate")

function LWActivityAlarmClockTemplateManager:__init()
  self.templateDict = {}
end

function LWActivityAlarmClockTemplateManager:__delete()
  self.templateDict = nil
end

function LWActivityAlarmClockTemplateManager:GetTemplate(templateId)
  if self.templateDict[templateId] == nil then
    local lineData = LocalController:instance():getLine(TableName.Activity_Clock, templateId)
    if lineData == nil then
      Logger.LogError("LWActivityAlarmClockTemplateManager GetTemplate lineData is nil id:" .. tostring(templateId))
      return nil
    end
    local template = LWActivityAlarmClockTemplate.New()
    template:Init(lineData)
    self.templateDict[templateId] = template
  end
  return self.templateDict[templateId]
end

return LWActivityAlarmClockTemplateManager
