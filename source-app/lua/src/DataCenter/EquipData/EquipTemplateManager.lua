local EquipTemplateManager = BaseClass("EquipTemplateManager")
local EquipTemplate = require("DataCenter.EquipData.EquipTemplate")

local function __init(self)
  self.templateDict = {}
  self.slotTemplateDic = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDict = nil
  self.slotTemplateDic = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Equip, function(id, lineData)
    local template = EquipTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    if self.slotTemplateDic[template.slot] == nil then
      self.slotTemplateDic[template.slot] = {}
    end
    table.insert(self.slotTemplateDic[template.slot], template)
  end)
end

local function GetTemplate(self, id)
  return self.templateDict[tonumber(id)]
end

local function GetAllCanCraftTemplateBySlotType(self, slotType)
  local result = {}
  if self.slotTemplateDic[slotType] ~= nil then
    for _, template in pairs(self.slotTemplateDic[slotType]) do
      if template.canCraft then
        table.insert(result, template)
      end
    end
  end
  return result
end

local function GetTemplateBySlotTypeAndQualityAndHeroType(self, slotType, heroType, quality)
  local result = {}
  if self.slotTemplateDic[slotType] ~= nil then
    for _, template in pairs(self.slotTemplateDic[slotType]) do
      if heroType == nil or heroType <= 0 then
        if template.quality == quality then
          return template
        end
      elseif template.heroType == heroType and template.quality == quality then
        return template
      end
    end
  end
  return nil
end

local function GetCanCraftMaxPowerEquip(self, buildlingLevel)
  local maxPower = 0
  local maxPowerEquip
  for _, template in pairs(self.templateDict) do
    if not (buildlingLevel < template.unlock_Level) then
      for itemId, needCount in pairs(template.cost_Items) do
        local count = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
        if needCount > count then
          goto lbl_28
        end
      end
      local power = template.power
      if maxPower < power then
        maxPower = power
        maxPowerEquip = template
      end
    end
    ::lbl_28::
  end
  return maxPowerEquip
end

local function GetEquipIconById(self, id)
  local template = self:GetTemplate(id)
  if template == nil then
    return nil
  end
  return template.icon
end

EquipTemplateManager.__init = __init
EquipTemplateManager.__delete = __delete
EquipTemplateManager.InitAllTemplate = InitAllTemplate
EquipTemplateManager.GetTemplate = GetTemplate
EquipTemplateManager.GetAllCanCraftTemplateBySlotType = GetAllCanCraftTemplateBySlotType
EquipTemplateManager.GetTemplateBySlotTypeAndQualityAndHeroType = GetTemplateBySlotTypeAndQualityAndHeroType
EquipTemplateManager.GetCanCraftMaxPowerEquip = GetCanCraftMaxPowerEquip
EquipTemplateManager.GetEquipIconById = GetEquipIconById
return EquipTemplateManager
