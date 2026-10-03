local ActivityPartyTemplateManager = BaseClass("ActivityPartyTemplateManager")
local ActivityPartyTemplate = require("DataCenter.ActivityThanksGivingTemplateManager.ActivityPartyTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetActBanquetTemplate(self, id)
  local numId = tonumber(id)
  if self.templateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Activity_Party, tostring(id))
    if oneTemplate ~= nil then
      local item = ActivityPartyTemplate.New()
      item:ParseData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[numId]
end

ActivityPartyTemplateManager.__init = __init
ActivityPartyTemplateManager.__delete = __delete
ActivityPartyTemplateManager.GetActBanquetTemplate = GetActBanquetTemplate
return ActivityPartyTemplateManager
