local PveAtomTemplateManager = BaseClass("PveAtomTemplateManager")
local PveAtomTemplate = require("DataCenter.PveAtomTemplateManager.PveAtomTemplate")

function PveAtomTemplateManager:__init()
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.PVEAtom, function(_, line)
    local template = PveAtomTemplate.New()
    template:InitData(line)
    self.templateDict[template.id] = template
  end)
end

function PveAtomTemplateManager:__delete()
  self.templateDict = {}
end

function PveAtomTemplateManager:GetTemplate(id)
  return self.templateDict[tonumber(id)]
end

function PveAtomTemplateManager:GetCostStamina(id)
  local temp = self:GetTemplate(id)
  if temp ~= nil then
    return temp.energy_cost
  end
  return 0
end

function PveAtomTemplateManager:GetResType(id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    for _, v in ipairs(template.outResource) do
      return v.resourceType
    end
  end
  return nil
end

function PveAtomTemplateManager:GetResItemId(id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    for _, v in ipairs(template.outResItem) do
      return v.itemId
    end
  end
  return nil
end

return PveAtomTemplateManager
