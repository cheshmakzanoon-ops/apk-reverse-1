local WorldTriggerTemplateManager = BaseClass("WorldTriggerTemplateManager")
local WorldTriggerTemplate = require("DataCenter.WorldTrigger.WorldTriggerTemplate")

function WorldTriggerTemplateManager:__init()
  self:InitMeta()
end

function WorldTriggerTemplateManager:__delete()
  self:Destroy()
end

function WorldTriggerTemplateManager:Destroy()
  for _, v in pairs(self.allMeta) do
    v:Delete()
  end
  self.allMeta = nil
end

function WorldTriggerTemplateManager:InitMeta()
  if not LocalController:instance():hasTable(TableName.WorldTrigger) then
    return
  end
  self.allMeta = {}
  LocalController:instance():visitTable(TableName.WorldTrigger, function(id, lineData)
    if lineData ~= nil then
      local meta = WorldTriggerTemplate.New()
      meta:InitConfig(lineData)
      self.allMeta[meta.id] = meta
    end
  end)
end

function WorldTriggerTemplateManager:GetAllMeta()
  return self.allMeta
end

function WorldTriggerTemplateManager:GetMeta(id)
  return self.allMeta and self.allMeta[id]
end

return WorldTriggerTemplateManager
