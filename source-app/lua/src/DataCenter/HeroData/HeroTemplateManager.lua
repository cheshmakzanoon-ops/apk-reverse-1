local HeroTemplateManager = BaseClass("HeroTemplateManager")
local HeroTemplate = require("DataCenter.HeroData.HeroTemplate")

local function __init(self)
  self.templateDict = {}
  self.skillId2SlotIndex = {}
end

local function __delete(self)
  self.templateDict = nil
  self.UltimateSkillIds = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Hero, function(id, lineData)
    local template = HeroTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    for slotIndex, skillId in ipairs(template.skills) do
      self.skillId2SlotIndex[skillId] = slotIndex
    end
  end)
end

local function GetTemplate(self, id)
  local _id = tonumber(id)
  if self.templateDict[_id] then
    return self.templateDict[_id]
  end
  local lineData = LocalController:instance():getLine(TableName.LW_Hero, id)
  if lineData == nil then
    Logger.LogError("HeroTemplateManager GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = HeroTemplate.New()
  template:InitData(lineData)
  self.templateDict[_id] = template
  for slotIndex, skillId in ipairs(template.skills) do
    self.skillId2SlotIndex[skillId] = slotIndex
  end
  return template
end

local function IsUltimate(self, skillId)
  local index = self:GetSlotIndex(skillId)
  return index and index == 2
end

local function GetSlotIndex(self, skillId)
  local zeroSkillId = skillId // 10 * 10
  local ret = self.skillId2SlotIndex[zeroSkillId]
  if not ret then
    Logger.LogError("\232\175\165\230\138\128\232\131\189\228\184\141\229\177\158\228\186\142\228\187\187\228\189\149\232\139\177\233\155\132\239\188\140\230\151\160\230\179\149\231\161\174\229\174\154\228\187\150\231\154\132\230\167\189\228\189\141\239\188\154" .. skillId)
  end
  return ret
end

HeroTemplateManager.__init = __init
HeroTemplateManager.__delete = __delete
HeroTemplateManager.InitAllTemplate = InitAllTemplate
HeroTemplateManager.GetTemplate = GetTemplate
HeroTemplateManager.IsUltimate = IsUltimate
HeroTemplateManager.GetSlotIndex = GetSlotIndex
return HeroTemplateManager
