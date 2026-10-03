local HeroSkillTemplateManager = BaseClass("HeroSkillTemplateManager")
local Resource = CS.GameEntry.Resource
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.dataDict = {}
  self.skillEnhanceEffectDict = {}
end

local function __delete(self)
  self.dataDict = nil
  self.skillEnhanceEffectDict = nil
end

local function GetTemplate(self, id)
  if self.dataDict[id] then
    return self.dataDict[id]
  end
  local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Hero_Skill), id)
  if lineData == nil then
    Logger.LogError("HeroSkillTemplateManager GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local skillTemplateData = HeroSkillTemplate.New()
  skillTemplateData:InitConfig(lineData)
  self.dataDict[id] = skillTemplateData
  return skillTemplateData
end

local function GetMaxStarSkillBySkillId(self, id)
  local skillTemplate = self:GetTemplate(id)
  if skillTemplate == nil then
    return id
  end
  local maxStar = skillTemplate.maxStar
  local groupId = skillTemplate.group
  local maxLevelSkillId = groupId + maxStar
  local template = self:GetTemplate(maxLevelSkillId)
  if template then
    return template.id
  else
    return id
  end
end

local function GetNeedRankByStar(self, groupId, star)
  local skillTemplate = self:GetTemplate(groupId + star)
  if skillTemplate == nil then
    return 0
  end
  return skillTemplate.needRank
end

local function IsUltimate(self, skillId)
  return DataCenter.HeroTemplateManager:IsUltimate(skillId)
end

local function GetSlotIndex(self, skillId)
  return DataCenter.HeroTemplateManager:GetSlotIndex(skillId)
end

local function GetSkillEnhanceEffectByGroup(self, groupId)
  if self.skillEnhanceEffectDict[groupId] then
    return self.skillEnhanceEffectDict[groupId]
  end
  local skillEnhanceEffect = {}
  local skillTemplate = self:GetTemplate(groupId)
  if skillTemplate == nil then
    return skillEnhanceEffect
  end
  local tempDict = {}
  for i = 1, skillTemplate.maxStar + 1 do
    local template = self:GetTemplate(groupId + (i - 1))
    if template == nil then
      break
    end
    local enhanceEffectKey = template.enhanceEffectKey
    if not string.IsNullOrEmpty(enhanceEffectKey) then
      local enhanceEffectParams = template.enhanceEffectParams
      local resultValue = Localization:GetString(enhanceEffectKey, SafeUnpack(enhanceEffectParams))
      tempDict[template.star] = resultValue
    end
  end
  for k, v in pairs(tempDict) do
    table.insert(skillEnhanceEffect, {star = k, effect = v})
  end
  table.sort(skillEnhanceEffect, function(a, b)
    return a.star < b.star
  end)
  self.skillEnhanceEffectDict[groupId] = skillEnhanceEffect
  return skillEnhanceEffect
end

local function SkillGroupHasNewEnhanceEffect(self, groupId)
  local skillEnhanceEffect = self:GetSkillEnhanceEffectByGroup(groupId)
  return not table.IsNullOrEmpty(skillEnhanceEffect)
end

local function GetSkillGroupMaxLevel(self, groupId, addMaxLv)
  local skillTemplate = self:GetTemplate(groupId)
  if skillTemplate == nil then
    return 0
  end
  local maxStarId = groupId + skillTemplate.maxStar
  local maxStarSkillTemplate = self:GetTemplate(maxStarId)
  if maxStarSkillTemplate == nil then
    return 0
  end
  return maxStarSkillTemplate.maxLevel + addMaxLv or 0
end

local function GetSkillPower(self, skillId, level)
  if not skillId then
    return 0
  end
  level = level or 1
  local skillTemplate = self:GetTemplate(skillId)
  if skillTemplate == nil then
    return 0
  end
  return skillTemplate:GetPowerByLevel(level)
end

local function GetSkillPowerV2(self, skillId, tierEffectValue)
  if not skillId then
    return 0
  end
  local skillTemplate = self:GetTemplate(skillId)
  if skillTemplate == nil then
    return 0
  end
  local base = skillTemplate.power[1]
  local upValue = skillTemplate.power[2] or 0
  local power = base + upValue * tierEffectValue
  return power
end

local function GetTemplateByGroupIdAndStar(self, groupId, star)
  local skillTemplate = self:GetTemplate(groupId + star)
  if skillTemplate == nil then
    return nil
  end
  return skillTemplate
end

local function GetSkillMaxLv(self, skillId)
  local skillTemplate = self:GetTemplate(skillId)
  if skillTemplate == nil then
    return 0
  end
  return skillTemplate.maxLevel
end

local function GetMaxSkillIdByGroupAndRank(self, group, rank)
  local skillTemplate = self:GetTemplateByGroupIdAndStar(group, 0)
  if not skillTemplate then
    return group
  end
  local ret = group
  local star = skillTemplate.star
  local maxStar = skillTemplate.maxStar
  for i = star, maxStar do
    local template = self:GetTemplateByGroupIdAndStar(group, i)
    if template and rank < template.needRank then
      return ret
    end
    ret = template.id
  end
  return ret
end

HeroSkillTemplateManager.__init = __init
HeroSkillTemplateManager.__delete = __delete
HeroSkillTemplateManager.GetTemplate = GetTemplate
HeroSkillTemplateManager.GetMaxStarSkillBySkillId = GetMaxStarSkillBySkillId
HeroSkillTemplateManager.GetNeedRankByStar = GetNeedRankByStar
HeroSkillTemplateManager.IsUltimate = IsUltimate
HeroSkillTemplateManager.GetSlotIndex = GetSlotIndex
HeroSkillTemplateManager.GetSkillEnhanceEffectByGroup = GetSkillEnhanceEffectByGroup
HeroSkillTemplateManager.SkillGroupHasNewEnhanceEffect = SkillGroupHasNewEnhanceEffect
HeroSkillTemplateManager.GetSkillGroupMaxLevel = GetSkillGroupMaxLevel
HeroSkillTemplateManager.GetSkillPower = GetSkillPower
HeroSkillTemplateManager.GetSkillPowerV2 = GetSkillPowerV2
HeroSkillTemplateManager.GetTemplateByGroupIdAndStar = GetTemplateByGroupIdAndStar
HeroSkillTemplateManager.GetSkillMaxLv = GetSkillMaxLv
HeroSkillTemplateManager.GetMaxSkillIdByGroupAndRank = GetMaxSkillIdByGroupAndRank
return HeroSkillTemplateManager
