local HeroUnlockSkillCostDataManager = BaseClass("HeroUnlockSkillCostDataManager")

local function __init(self)
  self.qualityAndSlotDict = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.qualityAndSlotDict = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Hero_Unlock_Skill, function(id, lineData)
    local cost = lineData:getValue("cost") or {}
    local quality = tonumber(lineData:getValue("quality")) or 0
    local slotIndex = tonumber(lineData:getValue("slots")) or 0
    if self.qualityAndSlotDict[quality] == nil then
      self.qualityAndSlotDict[quality] = {}
    end
    self.qualityAndSlotDict[quality][slotIndex] = cost
  end)
end

local function GetCostByQualityAndSlot(self, quality, slotIndex)
  if table.containsKey(self.qualityAndSlotDict, quality) and table.containsKey(self.qualityAndSlotDict[quality], slotIndex) then
    return self.qualityAndSlotDict[quality][slotIndex]
  end
  return nil
end

HeroUnlockSkillCostDataManager.__init = __init
HeroUnlockSkillCostDataManager.__delete = __delete
HeroUnlockSkillCostDataManager.InitAllTemplate = InitAllTemplate
HeroUnlockSkillCostDataManager.GetCostByQualityAndSlot = GetCostByQualityAndSlot
return HeroUnlockSkillCostDataManager
