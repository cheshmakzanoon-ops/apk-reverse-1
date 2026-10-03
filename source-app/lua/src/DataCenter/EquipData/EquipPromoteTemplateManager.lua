local EquipPromoteTemplateManager = BaseClass("EquipPromoteTemplateManager")
local EquipPromoteTemplate = require("DataCenter.EquipData.EquipPromoteTemplate")

local function __init(self)
  self.templateDict = {}
  self.dic = {}
end

local function __delete(self)
  self.templateDict = nil
  self.dic = nil
end

local function GetTemplate(self, id)
  if self.templateDict[id] == nil then
    local template = EquipPromoteTemplate.New()
    template:InitData(LocalController:instance():getLine(TableName.LW_Equip_Promote, id))
    self.templateDict[id] = template
  end
  return self.templateDict[id]
end

local function GetEquipUsedItem(self, promoteLevel)
  local usedItems = {}
  if promoteLevel == 0 then
    return usedItems
  end
  for i = 1, promoteLevel do
    local template = self:GetTemplate(i)
    if template ~= nil then
      for _, item in pairs(template.cost_resItem) do
        if usedItems[item.type] == nil then
          usedItems[item.type] = 0
        end
        usedItems[item.type] = usedItems[item.type] + item.value
      end
    end
  end
  return usedItems
end

EquipPromoteTemplateManager.__init = __init
EquipPromoteTemplateManager.__delete = __delete
EquipPromoteTemplateManager.GetTemplate = GetTemplate
EquipPromoteTemplateManager.GetEquipUsedItem = GetEquipUsedItem
return EquipPromoteTemplateManager
