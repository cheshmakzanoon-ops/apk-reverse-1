local LWAllianceLeaveTipsTemplateManager = BaseClass("LWAllianceLeaveTipsTemplateManager")
local LWAllianceLeaveTipsTemplate = require("DataCenter.AllianceData.LWAllianceLeaveTipsTemplate")

function LWAllianceLeaveTipsTemplateManager:__init()
  self.templateDict = {}
end

function LWAllianceLeaveTipsTemplateManager:__delete()
  self.templateDict = nil
end

function LWAllianceLeaveTipsTemplateManager:GetTemplate(templateId)
  if self.templateDict[templateId] == nil then
    self:GetAllTemplates()
  end
  return self.templateDict[templateId]
end

function LWAllianceLeaveTipsTemplateManager:GetAllTemplates()
  if table.count(self.templateDict) == 0 then
    LocalController:instance():visitTable(TableName.Alliance_Leave_Tips, function(id, lineData)
      local template = LWAllianceLeaveTipsTemplate.New()
      template:Init(lineData)
      self.templateDict[template.id] = template
    end)
  end
  return self.templateDict
end

return LWAllianceLeaveTipsTemplateManager
