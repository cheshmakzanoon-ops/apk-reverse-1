local CampEffectTemplate = require("DataCenter.CampEffectManager.CampEffectTemplate")
local CampEffectManager = BaseClass("CampEffectManager")

local function __init(self)
  self.configs = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.configs = nil
end

local function InitAllTemplate(self)
  self.configs = {}
  LocalController:instance():visitTable(TableName.Camp_effect, function(id, lineData)
    if lineData ~= nil then
      local item = CampEffectTemplate.New()
      item:InitConfig(lineData)
      if item.id ~= nil then
        self.configs[item.id] = item
      end
    end
  end)
end

local function GetTemplate(self, id)
  if self.configs[id] ~= nil then
    return self.configs[id]
  end
  return nil
end

local function GetAllTemplate(self)
  return DeepCopy(self.configs)
end

CampEffectManager.__init = __init
CampEffectManager.__delete = __delete
CampEffectManager.InitAllTemplate = InitAllTemplate
CampEffectManager.GetTemplate = GetTemplate
CampEffectManager.GetAllTemplate = GetAllTemplate
return CampEffectManager
