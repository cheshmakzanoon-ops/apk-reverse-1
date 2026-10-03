local EqiupWordTemplateManager = BaseClass("EqiupWordTemplateManager")
local EquipWordTemplate = require("DataCenter.EquipData.EquipWordTemplate")

local function __init(self)
  self.templateDict = {}
end

local function __delete(self)
  self.templateDict = nil
end

local function GetTemplate(self, id)
  if id == nil then
    return nil
  end
  local data = self.templateDict[id]
  if data == nil then
    data = EquipWordTemplate.New()
    data:InitData(LocalController:instance():getLine(TableName.LW_Equip_Attribute, id))
    self.templateDict[id] = data
  end
  return data
end

EqiupWordTemplateManager.__init = __init
EqiupWordTemplateManager.__delete = __delete
EqiupWordTemplateManager.GetTemplate = GetTemplate
return EqiupWordTemplateManager
