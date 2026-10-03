local ActivityMakeFoodTemplateManager = BaseClass("ActivityMakeFoodTemplateManager")
local ActivityMakeFoodTemplate = require("DataCenter.ActivityThanksGivingTemplateManager.ActivityMakeFoodTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetActCookingTemplate(self, id)
  local numId = tonumber(id)
  if self.templateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Activity_Make_Food, tostring(id))
    if oneTemplate ~= nil then
      local item = ActivityMakeFoodTemplate.New()
      item:ParseData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[numId]
end

ActivityMakeFoodTemplateManager.__init = __init
ActivityMakeFoodTemplateManager.__delete = __delete
ActivityMakeFoodTemplateManager.GetActCookingTemplate = GetActCookingTemplate
return ActivityMakeFoodTemplateManager
