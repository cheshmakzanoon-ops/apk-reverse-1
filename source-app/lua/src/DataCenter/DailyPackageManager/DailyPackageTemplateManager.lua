local DailyPackageTemplateManager = BaseClass("DailyPackageTemplateManager")
local DailyPackageTemplate = require("DataCenter.DailyPackageManager.DailyPackageTemplate")
local Localization = CS.GameEntry.Localization

function DailyPackageTemplateManager:__init()
  self.templates = {}
end

function DailyPackageTemplateManager:__delete()
  self.templates = nil
end

function DailyPackageTemplateManager:GetTemplate(id)
  if self.templates[id] then
    return self.templates[id]
  end
  local line = LocalController:instance():getLine(TableName.LW_DailyPackage, id)
  local template
  if line then
    template = DailyPackageTemplate.New()
    template:InitLine(line)
    self.templates[id] = template
    return template
  end
  return nil
end

return DailyPackageTemplateManager
