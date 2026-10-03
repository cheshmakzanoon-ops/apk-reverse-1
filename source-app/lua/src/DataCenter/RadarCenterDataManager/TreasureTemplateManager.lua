local WorldTreasureTemplate = require("DataCenter.RadarCenterDataManager.WorldTreasureTemplate")
local TreasureTemplateManager = BaseClass("TreasureTemplateManager")

local function __init(self)
  self.treasureTemplateDic = nil
end

local function __delete(self)
  self.treasureTemplateDic = nil
end

local function InitAllTemplate(self)
  self.treasureTemplateDic = {}
  LocalController:instance():visitTable(TableName.WorldTreasure, function(id, lineData)
    local item = WorldTreasureTemplate.New()
    item:InitData(lineData)
    self.treasureTemplateDic[id] = item
  end)
end

local function GetAllTemplate(self)
  if self.treasureTemplateDic == nil then
    self:InitAllTemplate()
  end
  return self.treasureTemplateDic
end

local function GetTemplate(self, id)
  if self.treasureTemplateDic == nil then
    self:InitAllTemplate()
  end
  return self.treasureTemplateDic[id]
end

local function GetAllTreasureSize(self)
  local ret = {}
  local template = self:GetAllTemplate()
  for i, v in pairs(template) do
    table.insert(ret, {
      itemId = v.id,
      size = v.size
    })
  end
  return ret
end

TreasureTemplateManager.__init = __init
TreasureTemplateManager.__delete = __delete
TreasureTemplateManager.InitAllTemplate = InitAllTemplate
TreasureTemplateManager.GetAllTemplate = GetAllTemplate
TreasureTemplateManager.GetTemplate = GetTemplate
TreasureTemplateManager.GetAllTreasureSize = GetAllTreasureSize
return TreasureTemplateManager
