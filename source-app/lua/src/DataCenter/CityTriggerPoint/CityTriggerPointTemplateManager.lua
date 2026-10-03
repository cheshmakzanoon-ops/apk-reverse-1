local CityTriggerPointTemplateManager = BaseClass("CityTriggerPointTemplateManager")
local CityTriggerPointTemplate = require("DataCenter.CityTriggerPoint.CityTriggerPointTemplate")
local Const = require("Scene.CityPioneer.Const")

function CityTriggerPointTemplateManager:__init()
  self.templ = nil
end

function CityTriggerPointTemplateManager:__delete()
  self.templ = nil
end

function CityTriggerPointTemplateManager:InitAllTemplate()
  self.templ = {}
  LocalController:instance():visitTable(TableName.APS_SINGLEMAP_PIONEER, function(id, lineData)
    local item = CityTriggerPointTemplate.New()
    item:InitData(lineData)
    if item.id ~= nil then
      self.templ[item.id] = item
    end
  end)
end

function CityTriggerPointTemplateManager:GetTemplate(id)
  if self.temp == nil then
    self:InitAllTemplate()
  end
  return self.templ[tonumber(id)]
end

function CityTriggerPointTemplateManager:GetAllTemplate()
  if self.templ == nil then
    self:InitAllTemplate()
  end
  return self.templ
end

return CityTriggerPointTemplateManager
