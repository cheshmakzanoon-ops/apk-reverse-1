local GuaranteedBoxTemplateManager = BaseClass("GuaranteedBoxTemplateManager")
local GuaranteedBoxTemplate = require("DataCenter.GuaranteedBoxTemplateManager.GuaranteedBoxTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetTemplate(self, id)
  if self.templateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_PointChest, tostring(id))
    if oneTemplate ~= nil then
      local item = GuaranteedBoxTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[tonumber(id)]
end

GuaranteedBoxTemplateManager.__init = __init
GuaranteedBoxTemplateManager.__delete = __delete
GuaranteedBoxTemplateManager.GetTemplate = GetTemplate
return GuaranteedBoxTemplateManager
