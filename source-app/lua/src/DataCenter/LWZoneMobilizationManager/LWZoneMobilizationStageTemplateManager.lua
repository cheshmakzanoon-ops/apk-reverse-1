local LWZoneMobilizationStageTemplateManager = BaseClass("LWZoneMobilizationStageTemplateManager")
local LWZoneMobilizationStageTemplate = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationStageTemplate")

function LWZoneMobilizationStageTemplateManager:__init()
  self.templateDict = {}
  self.allDonatedPhaseTemplate = {}
end

function LWZoneMobilizationStageTemplateManager:__delete()
  self.templateDict = nil
  self.allDonatedPhaseTemplate = nil
end

function LWZoneMobilizationStageTemplateManager:GetTemplate(templateId)
  if self.templateDict[templateId] == nil then
    local lineData = LocalController:instance():getLine(TableName.ZoneMobilizationStage, templateId)
    if lineData == nil then
      Logger.LogError("LWZoneMobilizationStageTemplateManager GetTemplate lineData is nil id:" .. tostring(templateId))
      return nil
    end
    local template = LWZoneMobilizationStageTemplate.New()
    template:UpdateData(lineData)
    self.templateDict[templateId] = template
  end
  return self.templateDict[templateId]
end

function LWZoneMobilizationStageTemplateManager:GetAllDonatedPhaseTemplate()
  if table.count(self.allDonatedPhaseTemplate) == 0 then
    LocalController:instance():visitTable(TableName.ZoneMobilizationStage, function(id, lineData)
      local template = self:GetTemplate(id)
      if template and template.stage_type == ZoneMobilizationStageType.Donated then
        self.allDonatedPhaseTemplate[template.id] = template
      end
    end)
  end
  return self.allDonatedPhaseTemplate
end

return LWZoneMobilizationStageTemplateManager
