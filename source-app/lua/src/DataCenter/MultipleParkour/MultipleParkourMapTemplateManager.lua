local MultipleParkourMapTemplateManager = BaseClass("MultipleParkourMapTemplateManager")
local MultipleParkourMapTemplate = require("DataCenter.MultipleParkour.MultipleParkourMapTemplate")

function MultipleParkourMapTemplateManager:__init()
  self.templateDict = {}
end

function MultipleParkourMapTemplateManager:__delete()
  self.templateDict = nil
end

function MultipleParkourMapTemplateManager:GetTemplate(id)
  id = tonumber(id)
  if table.containsKey(self.templateDict, id) then
    return self.templateDict[id]
  end
  local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Activity_Multiply_Map), id)
  if lineData == nil then
    Logger.LogError("MultipleParkourMapTemplateManager.GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = MultipleParkourMapTemplate.New()
  template:InitData(lineData)
  self.templateDict[id] = template
  return template
end

function MultipleParkourMapTemplateManager:GetMapLevelList(mapType)
  if self.mapTypeDict == nil then
    self.mapTypeDict = {}
    LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Activity_Multiply_Map), function(id, lineData)
      local template = self.templateDict[id]
      if template == nil then
        template = MultipleParkourMapTemplate.New()
        self.templateDict[id] = template
      end
      template:InitData(lineData)
      local type = template.map_type
      local map = self.mapTypeDict[type]
      if map == nil then
        map = {}
        self.mapTypeDict[type] = map
      end
      table.insert(map, template)
    end)
    for _, v in pairs(self.mapTypeDict) do
      table.sort(v, function(a, b)
        local levelA = a.level
        local levelB = b.level
        if levelA ~= levelB then
          return levelA < levelB
        end
        local idA = a.id
        local idB = b.id
        return idA < idB
      end)
    end
  end
  return self.mapTypeDict[mapType]
end

return MultipleParkourMapTemplateManager
