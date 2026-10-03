local AlliancePayTemplateManager = BaseClass("AlliancePayTemplateManager")
local AlliancePayTemplate = require("DataCenter/AllianceMilitaryPayManager/AlliancePayTemplate")

local function __init(self)
  self.templateDict = {}
end

local function __delete(self)
  self.templateDict = nil
end

local function GetTemplate(self, id)
  if self.templateDict[id] ~= nil then
    return self.templateDict[id]
  end
  local line = LocalController:instance():getLine(TableName.alliance_pay, id)
  if line ~= nil then
    local template = AlliancePayTemplate.New()
    template:UpdateData(line)
    self.templateDict[id] = template
    return template
  end
end

local function GetRewardIdByGiftLevel(self, id, level)
  if not self.giftRangeList then
    local str = LuaEntry.DataConfig:TryGetStr("alliance_pay_config", "k1")
    local arr = string.string2table_ii_toList(str, ";", "|")
    self.giftRangeList = arr
  end
  local template = self:GetTemplate(id)
  local rewardList = template.rewardIds
  for i, v in ipairs(self.giftRangeList) do
    local minLevel = v[1] or 0
    local maxLevel = v[2] or 0
    if level >= minLevel and level <= maxLevel then
      return rewardList[i] or 0
    end
  end
  return 0
end

local function LoadAllTemplates(self)
  LocalController:instance():visitTable(TableName.alliance_pay, function(_, lineData)
    local template = AlliancePayTemplate.New()
    template:UpdateData(lineData)
    self.templateDict[template.id] = template
  end)
end

local function GetTemplatesByType(self, type)
  local templates = {}
  self:LoadAllTemplates()
  for id, template in pairs(self.templateDict) do
    if template.type == type then
      table.insert(templates, template)
    end
  end
  return templates
end

AlliancePayTemplateManager.__init = __init
AlliancePayTemplateManager.__delete = __delete
AlliancePayTemplateManager.GetTemplate = GetTemplate
AlliancePayTemplateManager.GetRewardIdByGiftLevel = GetRewardIdByGiftLevel
AlliancePayTemplateManager.GetTemplatesByType = GetTemplatesByType
AlliancePayTemplateManager.LoadAllTemplates = LoadAllTemplates
return AlliancePayTemplateManager
