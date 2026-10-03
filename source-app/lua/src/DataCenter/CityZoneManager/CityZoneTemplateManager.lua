local CityZoneTemplateManager = BaseClass("CityZoneTemplateManager")
local CityZoneTemplate = require("DataCenter.CityZoneManager.CityZoneTemplate")

function CityZoneTemplateManager:__init()
  self.templateDict = nil
end

function CityZoneTemplateManager:__delete()
  self.templateDict = nil
end

function CityZoneTemplateManager:Startup()
end

function CityZoneTemplateManager:InitTemplateDict()
  self.templateDict = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.BuildZone), function(_, line)
    local template = CityZoneTemplate.New()
    template:InitData(line)
    self.templateDict[template.id] = template
  end)
end

function CityZoneTemplateManager:GetTemplate(id)
  if self.templateDict == nil then
    self:InitTemplateDict()
  end
  return self.templateDict[tonumber(id)]
end

function CityZoneTemplateManager:GetAllTemplate()
  if self.templateDict == nil then
    self:InitTemplateDict()
  end
  return self.templateDict
end

return CityZoneTemplateManager
