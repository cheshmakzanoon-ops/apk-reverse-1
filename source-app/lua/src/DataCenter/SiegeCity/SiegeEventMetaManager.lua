local SiegeEventMetaManager = BaseClass("SiegeEventMetaManager")
local SiegeEventMeta = require("DataCenter.SiegeCity.SiegeEventMeta")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.templateDict = {}
end

local function __delete(self)
end

local function GetTemplate(self, id)
  id = tonumber(id)
  if table.containsKey(self.templateDict, id) then
    return self.templateDict[id]
  end
  local lineData = LocalController:instance():getLine(TableName.Event_City_Star, id)
  if lineData == nil then
    Logger.LogError("SiegeEventMeta GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = SiegeEventMeta.New()
  template:InitData(lineData)
  self.templateDict[id] = template
  return template
end

SiegeEventMetaManager.__init = __init
SiegeEventMetaManager.__delete = __delete
SiegeEventMetaManager.GetTemplate = GetTemplate
return SiegeEventMetaManager
