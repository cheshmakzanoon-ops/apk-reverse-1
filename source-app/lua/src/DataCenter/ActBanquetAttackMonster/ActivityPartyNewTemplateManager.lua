local ActivityPartyNewTemplateManager = BaseClass("ActivityPartyNewTemplateManager")
local ActivityPartyNewTemplate = require("DataCenter.ActBanquetAttackMonster.ActivityPartyNewTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetActBanquetTemplate(self, id)
  local numId = tonumber(id)
  if self.templateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Activity_Party_New, tostring(id))
    if oneTemplate ~= nil then
      local item = ActivityPartyNewTemplate.New()
      item:ParseData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[numId]
end

ActivityPartyNewTemplateManager.__init = __init
ActivityPartyNewTemplateManager.__delete = __delete
ActivityPartyNewTemplateManager.GetActBanquetTemplate = GetActBanquetTemplate
return ActivityPartyNewTemplateManager
