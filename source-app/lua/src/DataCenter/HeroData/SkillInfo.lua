local SkillInfo = BaseClass("SkillInfo")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.skillId = nil
  self.isUnlocked = false
end

local function __delete(self)
  self.hero = nil
  self.skillId = nil
  self.level = nil
  self.heroUuid = nil
  self.slotIndex = nil
  self.isUnlocked = nil
  self.uuid = nil
  self.skillTemplateData = nil
  self.cachedEffectsDesc = nil
end

local function UpdateSkillInfo(self, message)
  if message == nil then
    return
  end
  if message.skillId ~= nil then
    self.skillId = message.skillId
  end
  if message.level ~= nil then
    if not self.prevLevel then
      self.prevLevel = self.level
    end
    self.level = message.level
  end
  if message.heroUuid ~= nil then
    self.heroUuid = message.heroUuid
  end
  if message.slot ~= nil then
    self.slotIndex = message.slot
  end
  if message.state ~= nil then
    self.isUnlocked = message.state == 1
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  self.star = 0
  if message.star ~= nil then
    self.star = message.star
  end
end

local function CreateFromTemplate(self, templateId, unlocked, level, star, heroUuid)
  if templateId == nil or templateId < 0 then
    return
  end
  self.skillId = templateId
  self.skillTemplateData = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  if unlocked == nil then
    unlocked = false
  end
  self.isUnlocked = unlocked
  self.level = 1
  if level ~= nil then
    self.level = level
  end
  local maxLv = self:GetMaxLevel()
  if maxLv < self.level then
    self.level = maxLv
  end
  self.star = star or 0
  self.cachedEffectsDesc = nil
  if heroUuid ~= nil then
    self.heroUuid = heroUuid
  end
end

local function GetId(self)
  return self.skillId
end

local function GetLevel(self)
  return self.level
end

local function IsUnlock(self)
  return self.isUnlocked
end

local function GetSlotIndex(self)
  return self.slotIndex
end

local function GetDesc(self, containsNextLevel, colorStr, customTierSystemEffectValue)
  if self.skillTemplateData == nil then
    return ""
  end
  colorStr = colorStr or HeroEffectColorGreenStr
  local desc = self.skillTemplateData:GetSkillDescByLevel(self.level, containsNextLevel, colorStr, self:GetMaxLevel(), customTierSystemEffectValue)
  return desc
end

local function GetTemplateData(self)
  return self.skillTemplateData
end

local function GetAllDamage(self)
  return self.skillTemplateData:GetSkillEffects(self.level)
end

local function IsReachMaxLevel(self)
  return self.level >= self:GetMaxLevel()
end

local function GetBuff(self)
  return self.skillTemplateData:GetBuff()
end

local function GetType(self)
  return self.skillTemplateData.type
end

local function GetActionType(self)
  return self.skillTemplateData.actionType
end

local function GetPower(self)
  return self.skillTemplateData:GetPowerByLevel(self.level)
end

local function GetProperties(self)
  return self.skillTemplateData.property
end

local function GetPropertiesOutOfBattle(self)
  return self.skillTemplateData.outOfBattleProperties
end

local function GetName(self)
  if self.skillTemplateData then
    return Localization:GetString(self.skillTemplateData.name)
  else
    return ""
  end
end

local function GetMaxLevel(self)
  if self.skillTemplateData then
    local maxLv = self.skillTemplateData.maxLevel
    maxLv = maxLv + self:GetAddMaxLevel()
    return maxLv
  else
    return 0
  end
end

local function GetEffectsDesc(self)
  if not self.skillTemplateData then
    return {}
  end
  if self.cachedEffectsDesc == nil then
    local enhanceEffects = self.skillTemplateData:GetSortedEnhanceDescKeys()
    local effects = {}
    for __, v in pairs(enhanceEffects) do
      local param = {}
      param.desc = v.effect
      param.unlockStar = v.star
      table.insert(effects, param)
    end
    self.cachedEffectsDesc = effects
  end
  for __, effect in pairs(self.cachedEffectsDesc) do
    if effect.unlockStar <= self:GetStar() then
      effect.isUnlock = true
      effect.outDesc = effect.desc
    else
      effect.isUnlock = false
      if self:IsHeroAwakenSkill() then
        local star = effect.unlockStar
        local rank = DataCenter.HeroSkillTemplateManager:GetNeedRankByStar(self:GetGroupId(), star)
        effect.outDesc = Localization:GetString("hero_awaken_desc_22", rank // 5)
      else
        local star = effect.unlockStar
        local rank = DataCenter.HeroSkillTemplateManager:GetNeedRankByStar(self:GetGroupId(), star)
        local rankName = DataCenter.HeroRankTemplateManager:GetRankName(rank)
        effect.outDesc = Localization:GetString(151134, rankName)
      end
      effect.outDesc = string.format("%s <color=#F97077>%s</color>", effect.desc, effect.outDesc)
    end
  end
  return self.cachedEffectsDesc
end

local function GetUpgradeCostSkillPoint(self)
  local isReachMaxLevel = self:IsReachMaxLevel()
  if not isReachMaxLevel and self.skillTemplateData then
    return self.skillTemplateData:GetCostSkillPointCount(self.level)
  else
    return 0
  end
end

local function GetStar(self)
  if self.skillTemplateData then
    return self.skillTemplateData.star
  else
    return 0
  end
end

local function GetMaxStar(self)
  if self.skillTemplateData then
    return self.skillTemplateData.maxStar
  else
    return 0
  end
end

local function IsReachMaxStar(self)
  if self.skillTemplateData then
    return self.skillTemplateData.star >= self.skillTemplateData.maxStar
  else
    return false
  end
end

local function GetGroupId(self)
  if self.skillTemplateData then
    return self.skillTemplateData.group
  else
    return 0
  end
end

local function GetMaxStarSkillMaxLevel(self)
  if self.skillTemplateData then
    local skillId = DataCenter.HeroSkillTemplateManager:GetMaxStarSkillBySkillId(self.skillTemplateData.id)
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    return skillTemplate.maxLevel + self:GetAddMaxLevel()
  else
    return 0
  end
end

local function GetEffectsDescWeapon(self)
  if not self.skillTemplateData then
    return {}
  end
  if self.cachedEffectsDesc == nil then
    local enhanceEffects = self.skillTemplateData:GetSortedEnhanceDescKeys()
    local effects = {}
    for __, v in pairs(enhanceEffects) do
      local param = {}
      param.desc = v.effect
      param.unlockStar = v.star
      table.insert(effects, param)
    end
    self.cachedEffectsDesc = effects
  end
  for __, effect in pairs(self.cachedEffectsDesc) do
    if effect.unlockStar <= self:GetStar() then
      effect.isUnlock = true
      effect.outDesc = effect.desc
    else
      effect.isUnlock = false
      local star = effect.unlockStar
      local level = DataCenter.HeroSkillTemplateManager:GetNeedRankByStar(self:GetGroupId(), star)
      effect.outDesc = Localization:GetString("skill_desc_UAV_starup", level)
      effect.outDesc = string.format("%s <color=#F97077>%s</color>", effect.desc, effect.outDesc)
    end
  end
  return self.cachedEffectsDesc
end

local function GetEffectsDescTWSkillChip(self)
  if not self.skillTemplateData then
    return {}
  end
  if self.cachedEffectsDesc == nil then
    local enhanceEffects = self.skillTemplateData:GetSortedEnhanceDescKeys()
    local effects = {}
    for __, v in pairs(enhanceEffects) do
      local param = {}
      param.desc = v.effect
      param.unlockStar = v.star
      table.insert(effects, param)
    end
    self.cachedEffectsDesc = effects
  end
  for __, effect in pairs(self.cachedEffectsDesc) do
    if effect.unlockStar <= self:GetStar() then
      effect.isUnlock = true
      effect.outDesc = effect.desc
    else
      effect.isUnlock = false
      local star = effect.unlockStar
      local level = DataCenter.HeroSkillTemplateManager:GetNeedRankByStar(self:GetGroupId(), star)
      effect.outDesc = effect.desc
    end
  end
  return self.cachedEffectsDesc
end

local function GetGroupMaxLevel(self)
  if self.skillTemplateData then
    return DataCenter.HeroSkillTemplateManager:GetSkillGroupMaxLevel(self.skillTemplateData.group, self:GetAddMaxLevel())
  else
    return 0
  end
end

local function SetAddMaxLevel(self, addValue)
  self.addMaxLv = addValue
end

local function GetAddMaxLevel(self)
  if self:IsFocused() then
    return 0
  end
  if self:IsHeroAwakenSkill() then
    return 0
  end
  return self.addMaxLv or 0
end

local function IsFocused(self)
  if self.skillTemplateData == nil then
    return false
  end
  return self.skillTemplateData:IsFocused()
end

function SkillInfo:GetSkillCastType()
  if self.skillTemplateData then
    return self.skillTemplateData:GetSkillCastType()
  end
  return SkillCastType.None
end

function SkillInfo:GetSkillDisplayType()
  if self.skillTemplateData then
    return self.skillTemplateData:GetSkillDisplayType()
  end
  return 0
end

function SkillInfo:GetSkillDisplayCastType()
  local displayCastType = SkillCastType.None
  if self.skillTemplateData then
    displayCastType = self.skillTemplateData:GetSkillDisplayCastType()
  end
  if displayCastType <= SkillCastType.None then
    return self:GetSkillCastType()
  end
  return displayCastType
end

function SkillInfo:GetCoolDownTime(owner)
  if not owner or not owner.GetProperty then
    return self.skillTemplateData.attack_interval
  end
  local castType = self:GetSkillCastType()
  if castType == SkillCastType.AutoAttack then
    local attackSpeed = owner:GetProperty(75650)
    return self.skillTemplateData.attack_interval / (1 + attackSpeed)
  elseif castType == SkillCastType.Active then
    local coolDownReduce = owner:GetProperty(75750)
    return self.skillTemplateData.attack_interval / (1 + coolDownReduce)
  else
    return self.skillTemplateData.attack_interval
  end
end

function SkillInfo:GetPreCd()
  if self.skillTemplateData then
    return self.skillTemplateData.pre_cd or 0
  end
  return 0
end

function SkillInfo:IsReachGroupMaxLevel()
  return self.level >= self:GetGroupMaxLevel()
end

function SkillInfo.getters:skillTemplateData()
  self.skillTemplateData = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  return self.skillTemplateData
end

function SkillInfo:IsShowSkillPreviewBtn()
  if self.skillTemplateData then
    return self.skillTemplateData:IsShowSkillPreviewBtn()
  end
  return false
end

function SkillInfo:IsHeroAwakenSkill()
  if self.skillTemplateData then
    return self.skillTemplateData:IsHeroAwakenSkill()
  end
  return false
end

function SkillInfo:IsUltimateSkill()
  if self.skillTemplateData then
    return self.skillTemplateData:IsUltimateSkill()
  end
  return false
end

SkillInfo.__init = __init
SkillInfo.__delete = __delete
SkillInfo.UpdateSkillInfo = UpdateSkillInfo
SkillInfo.CreateFromTemplate = CreateFromTemplate
SkillInfo.GetId = GetId
SkillInfo.GetLevel = GetLevel
SkillInfo.IsUnlock = IsUnlock
SkillInfo.GetSlotIndex = GetSlotIndex
SkillInfo.GetDesc = GetDesc
SkillInfo.IsReachMaxLevel = IsReachMaxLevel
SkillInfo.GetTemplateData = GetTemplateData
SkillInfo.GetAllDamage = GetAllDamage
SkillInfo.GetBuff = GetBuff
SkillInfo.GetType = GetType
SkillInfo.GetActionType = GetActionType
SkillInfo.GetPower = GetPower
SkillInfo.GetProperties = GetProperties
SkillInfo.GetPropertiesOutOfBattle = GetPropertiesOutOfBattle
SkillInfo.GetName = GetName
SkillInfo.GetMaxLevel = GetMaxLevel
SkillInfo.GetEffectsDesc = GetEffectsDesc
SkillInfo.GetUpgradeCostSkillPoint = GetUpgradeCostSkillPoint
SkillInfo.GetStar = GetStar
SkillInfo.GetMaxStar = GetMaxStar
SkillInfo.IsReachMaxStar = IsReachMaxStar
SkillInfo.GetGroupId = GetGroupId
SkillInfo.GetMaxStarSkillMaxLevel = GetMaxStarSkillMaxLevel
SkillInfo.GetEffectsDescWeapon = GetEffectsDescWeapon
SkillInfo.GetGroupMaxLevel = GetGroupMaxLevel
SkillInfo.GetEffectsDescTWSkillChip = GetEffectsDescTWSkillChip
SkillInfo.SetAddMaxLevel = SetAddMaxLevel
SkillInfo.GetAddMaxLevel = GetAddMaxLevel
SkillInfo.IsFocused = IsFocused
return SkillInfo
