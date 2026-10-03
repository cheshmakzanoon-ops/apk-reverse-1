local CollectResourceTemplateManager = BaseClass("CollectResourceTemplateManager")
local CollectResourceTemplate = require("DataCenter.CollectResourceManager.CollectResourceTemplate")

function CollectResourceTemplateManager:__init()
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.CollectResource, function(_, line)
    local template = CollectResourceTemplate.New()
    template:InitData(line)
    self.templateDict[template.id] = template
  end)
end

function CollectResourceTemplateManager:__delete()
  self.templateDict = {}
end

function CollectResourceTemplateManager:GetTemplate(id)
  return self.templateDict[tonumber(id)]
end

function CollectResourceTemplateManager:GetAllTemplateByResourceType(resourceType, itemId)
  local result = {}
  for k, v in pairs(self.templateDict) do
    if v:IsResourceByType(resourceType, itemId) then
      table.insert(result, v)
    end
  end
  return result
end

function CollectResourceTemplateManager:GetAllTemplate()
  return self.templateDict
end

return CollectResourceTemplateManager
