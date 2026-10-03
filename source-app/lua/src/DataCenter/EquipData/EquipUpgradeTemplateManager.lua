local EquipUpgradeTemplateManager = BaseClass("EquipUpgradeTemplateManager")
local EquipUpgradeTemplate = require("DataCenter.EquipData.EquipUpgradeTemplate")

local function __init(self)
  self.templateDict = {}
  self.dic = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDict = nil
  self.dic = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Equip_Upgrade, function(id, lineData)
    local template = EquipUpgradeTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    if self.dic[template.slot] == nil then
      self.dic[template.slot] = {}
    end
    if self.dic[template.slot][template.quality] == nil then
      self.dic[template.slot][template.quality] = {}
    end
    self.dic[template.slot][template.quality][template.heroType] = template
  end)
end

local function GetTemplate(self, id)
  return self.templateDict[id]
end

local function GetTemplateBySlotQualityHeroType(self, slot, quality, heroType)
  if self.dic[slot] == nil then
    return nil
  end
  if self.dic[slot][quality] == nil then
    return nil
  end
  return self.dic[slot][quality][heroType]
end

local function GetEquipUsedItem(self, slot, quality, heroType, level)
  if level == 0 then
    return 0
  end
  local template = self:GetTemplateBySlotQualityHeroType(slot, quality, heroType)
  if template == nil then
    return 0
  end
  local usedItem = 0
  for i = 1, level do
    usedItem = usedItem + template:GetCostStoneByLevel(i - 1)
  end
  if 0 < usedItem then
    local returnRatio = DataCenter.HeroParamDataManager.ReturnEquipStoneRatio
    usedItem = math.floor(usedItem * returnRatio)
  end
  return usedItem
end

EquipUpgradeTemplateManager.__init = __init
EquipUpgradeTemplateManager.__delete = __delete
EquipUpgradeTemplateManager.InitAllTemplate = InitAllTemplate
EquipUpgradeTemplateManager.GetTemplate = GetTemplate
EquipUpgradeTemplateManager.GetTemplateBySlotQualityHeroType = GetTemplateBySlotQualityHeroType
EquipUpgradeTemplateManager.GetEquipUsedItem = GetEquipUsedItem
return EquipUpgradeTemplateManager
