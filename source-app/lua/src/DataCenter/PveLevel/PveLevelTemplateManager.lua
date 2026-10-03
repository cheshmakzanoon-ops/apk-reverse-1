local PveLevelTemplateManager = BaseClass("PveLevelTemplateManager")
local PveLevelTemplate = require("DataCenter.PveLevel.PveLevelTemplate")
local NoTemplate = "NoTemplate"

local function __init(self)
  self.templateDict = {}
end

local function __delete(self)
  self.templateDict = nil
end

local function GetTemplate(self, id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.templateDict[id] == NoTemplate then
    return nil
  end
  if self.templateDict[id] ~= nil then
    return self.templateDict[id]
  end
  local line = LocalController:instance():getLine(TableName.PVELevel, id)
  if line ~= nil then
    local template = PveLevelTemplate.New()
    template:InitData(line)
    self.templateDict[id] = template
    return template
  else
    self.templateDict[id] = NoTemplate
    return nil
  end
end

PveLevelTemplateManager.__init = __init
PveLevelTemplateManager.__delete = __delete
PveLevelTemplateManager.GetTemplate = GetTemplate
return PveLevelTemplateManager
