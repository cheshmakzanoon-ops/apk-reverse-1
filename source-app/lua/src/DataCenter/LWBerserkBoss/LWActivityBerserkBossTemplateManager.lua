local LWActivityBerserkBossTemplateManager = BaseClass("LWActivityBerserkBossTemplateManager")
local LWActivityBerserkBossTemplate = require("DataCenter.LWBerserkBoss.LWActivityBerserkBossTemplate")

function LWActivityBerserkBossTemplateManager:__init()
  self.templateDict = {}
end

function LWActivityBerserkBossTemplateManager:__delete()
  self.templateDict = nil
end

function LWActivityBerserkBossTemplateManager:GetTemplate(templateId)
  if self.templateDict[templateId] == nil then
    local lineData = LocalController:instance():getLine(TableName.ActivityBerserkBoss, templateId)
    if lineData == nil then
      Logger.LogError("LWActivityBerserkBossTemplateManager GetTemplate lineData is nil id:" .. tostring(templateId))
      return nil
    end
    local template = LWActivityBerserkBossTemplate.New()
    template:Init(lineData)
    self.templateDict[templateId] = template
  end
  return self.templateDict[templateId]
end

return LWActivityBerserkBossTemplateManager
