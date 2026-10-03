local ArrowTipTemplateManager = BaseClass("ArrowTipTemplateManager")
local ArrowTipTemplate = require("DataCenter.ArrowTipManager.ArrowTipTemplate")

local function __init(self)
  self.templates = {}
end

local function __delete(self)
  self.templates = nil
end

local function InitTemplate(self)
  LocalController:instance():visitTable(TableName.ArrowTip, function(id, lineData)
    local item = ArrowTipTemplate.New()
    item:InitData(lineData)
    self.templates[item.type] = item
  end)
end

local function GetTemplateByType(self, type)
  if table.count(self.templates) == 0 then
    self:InitTemplate()
  end
  for _, v in pairs(self.templates) do
    if v.type == type then
      return v
    end
  end
  return nil
end

local function IsCanShowArrow(self, arrowType)
  local template = self:GetTemplateByType(arrowType)
  if template ~= nil then
    return template:CheckCondition(-1)
  end
  return false
end

ArrowTipTemplateManager.__init = __init
ArrowTipTemplateManager.__delete = __delete
ArrowTipTemplateManager.InitTemplate = InitTemplate
ArrowTipTemplateManager.GetTemplateByType = GetTemplateByType
ArrowTipTemplateManager.IsCanShowArrow = IsCanShowArrow
return ArrowTipTemplateManager
