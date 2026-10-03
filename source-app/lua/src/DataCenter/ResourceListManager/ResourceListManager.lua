local ResourceListManager = BaseClass("ResourceListManager")
local ResourceSpeedShowTemplate = require("DataCenter/ResourceListManager/ResourceSpeedShowTemplate")
local Localization = CS.GameEntry.Localization
ResourceListManager.ShowType = {Resource = 1, Material = 2}
ResourceListManager.Type = {
  Resource = 1,
  ResourceItem = 2,
  Goods = 3
}
ResourceListManager.TimeType = {Hour = 1, Day = 2}

function ResourceListManager:__init()
  self.speedShowTemplateDict = nil
  self.speedShowTemplates = nil
end

function ResourceListManager:__delete()
  self.speedShowTemplateDict = nil
  self.speedShowTemplates = nil
end

function ResourceListManager:TryInitSpeedShowTemplate()
  if self.speedShowTemplateDict == nil or self.speedShowTemplates == nil then
    self.speedShowTemplateDict = {}
    self.speedShowTemplates = {}
    LocalController:instance():visitTable(TableName.RESOURCE_SPEED_SHOW, function(id, lineData)
      if self.speedShowTemplateDict[id] == nil and lineData ~= nil then
        local template = ResourceSpeedShowTemplate.New()
        template:UpdateData(lineData)
        self.speedShowTemplateDict[id] = template
        table.insert(self.speedShowTemplates, template)
      end
    end)
  end
end

function ResourceListManager:GetAllSpeedShowTemplates()
  self:TryInitSpeedShowTemplate()
  return self.speedShowTemplates
end

function ResourceListManager:GetAllSpeedShowTemplatesByShowType(showType)
  self:TryInitSpeedShowTemplate()
  local res = {}
  for i, v in ipairs(self.speedShowTemplates) do
    if v.show_type == showType then
      table.insert(res, v)
    end
  end
  table.sort(res, function(a, b)
    return a.order < b.order
  end)
  return res
end

function ResourceListManager:GetSpeedShowTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  self:TryInitSpeedShowTemplate()
  if self.speedShowTemplateDict[id] == nil then
    Logger.LogWarning("ResourceListManager template warning: trying to get nonexistent id " .. id)
    return nil
  end
  return self.speedShowTemplateDict[id]
end

return ResourceListManager
