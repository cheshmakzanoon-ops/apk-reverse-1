local MultipleParkourDoorTemplateManager = BaseClass("MultipleParkourDoorTemplateManager")
local MultipleParkourDoorTemplate = require("DataCenter.MultipleParkour.MultipleParkourDoorTemplate")

function MultipleParkourDoorTemplateManager:__init()
  self.templateDict = {}
end

function MultipleParkourDoorTemplateManager:__delete()
  self.templateDict = nil
end

function MultipleParkourDoorTemplateManager:GetTemplate(id)
  id = tonumber(id)
  if table.containsKey(self.templateDict, id) then
    return self.templateDict[id]
  end
  local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Activity_Multiply_Door), id)
  if lineData == nil then
    Logger.LogError("MultipleParkourDoorTemplateManager.GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = MultipleParkourDoorTemplate.New()
  template:InitData(lineData)
  self.templateDict[id] = template
  return template
end

return MultipleParkourDoorTemplateManager
