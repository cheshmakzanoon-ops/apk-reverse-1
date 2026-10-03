local ActivityPartyMonsterTemplateManager = BaseClass("ActivityPartyMonsterTemplateManager")
local ActivityPartyMonsterTemplate = require("DataCenter.ActBanquetAttackMonster.ActivityPartyMonsterTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetTemplate(self, id)
  local numId = tonumber(id)
  if self.templateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Activity_Party_Monster, tostring(id))
    if oneTemplate ~= nil then
      local item = ActivityPartyMonsterTemplate.New()
      item:ParseData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[numId]
end

ActivityPartyMonsterTemplateManager.__init = __init
ActivityPartyMonsterTemplateManager.__delete = __delete
ActivityPartyMonsterTemplateManager.GetTemplate = GetTemplate
return ActivityPartyMonsterTemplateManager
