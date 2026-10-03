local PveBuffTemplateManager = BaseClass("PveBuffTemplateManager")
local PveBuffTemplate = require("DataCenter.PveBuffTemplateManager.PveBuffTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetTemplate(self, id)
  local numId = tonumber(id)
  if self.templateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.PveBuff, tostring(id))
    if oneTemplate ~= nil then
      local item = PveBuffTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[numId]
end

PveBuffTemplateManager.__init = __init
PveBuffTemplateManager.__delete = __delete
PveBuffTemplateManager.GetTemplate = GetTemplate
return PveBuffTemplateManager
