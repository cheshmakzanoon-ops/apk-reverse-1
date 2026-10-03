local ActInfiniteGiftTemplateDataManager = BaseClass("ActInfiniteGiftTemplateDataManager")
local Localization = CS.GameEntry.Localization
local ActInfiniteGiftTemplate = require("DataCenter.ActInfiniteGiftDataManager.ActInfiniteGiftTemplate")

local function __init(self)
  self.templateDict = {}
end

local function __delete(self)
  self.templateDict = nil
end

local function GetTemplate(self, id)
  if table.containsKey(self.templateDict, tonumber(id)) then
    return self.templateDict[tonumber(id)]
  end
  local lineData = LocalController:instance():getLine(TableName.LW_Infinite_Gift_Group, id)
  if lineData == nil then
    Logger.LogError("ActInfiniteGiftTemplateDataManager GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = ActInfiniteGiftTemplate.New()
  template:InitConfig(lineData)
  self.templateDict[id] = template
  return template
end

ActInfiniteGiftTemplateDataManager.__init = __init
ActInfiniteGiftTemplateDataManager.__delete = __delete
ActInfiniteGiftTemplateDataManager.GetTemplate = GetTemplate
return ActInfiniteGiftTemplateDataManager
