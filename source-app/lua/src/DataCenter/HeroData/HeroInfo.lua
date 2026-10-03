local HeroInfo = BaseClass("HeroInfo")
local AdvanceReqData = require("DataCenter.HeroData.AdvanceReqData")
local Localization = CS.GameEntry.Localization
local HeroPropertyGroupedDetailData = require("DataCenter/HeroData/HeroAwaken/HeroPropertyGroupedDetailData")
local level2Id = {}
local heroReset_k7

local function __init(self)
  self.uuid = 0
  self.heroId = 0
  self.state = 0
  self.exp = 0
  self.level = 1
  self.quality = 0
  self.lastLevel = 0
  self.lastLife = 0
  self.lastPower = 0
  self.power = 0
  self.propertyPower = 0
  self.skillPower = 0
  self.config = nil
  self.camp = 0
  self.rarity = 0
  self.skillDict = nil
  self.skillList = nil
  self.lastArkId = 0
  self.arkId = 0
  self.effectDict = {}
  self.curMaxLevel = 0
  self.rank = 1
  self.maxRank = 1
  self.configQuality = 0
  self.advanceReq = nil
  self.isMaster = true
  self.modelId = 1
  self.gender = 0
  self.firstName = ""
  self.bigName = ""
  self.lastName = ""
  self.nickName = ""
  self.atk = 0
  self.def = 0
  self.tagIds = {}
  self.canChangeFate = false
  self.propertyData = nil
  self.prevPropertyData = nil
  self.propertyGroupedDetailData = nil
  self.weaponInfo = nil
  self.fragId = 0
  self.costCommonFrag = 0
  self.costExclusiveFrag = 0
  self.costSkillPoint = 0
  self.propertyTemplateType = 0
  self.equipUids = nil
  self.equipPower = 0
  self.newUnlockSkillTags = {}
  self.honorLevel = 0
  self.maxHonorLevel = 0
  self.fromTemplate = false
  self.uniqueWeaponLv = 0
  self.realWeaponLv = 0
  self.uwUnitLvMap = {}
  self.awakenLv = 0
  self.skinId = 0
end

local function __delete(self)
  self.uuid = nil
  self.heroId = nil
  self.meta = nil
  self.state = nil
  self.exp = nil
  self.level = nil
  self.quality = nil
  self.lastLevel = nil
  self.lastAtk = nil
  self.lastDef = nil
  self.lastLife = nil
  self.lastPower = nil
  self.atk = nil
  self.def = nil
  self.power = nil
  self.config = nil
  self.camp = nil
  self.rarity = nil
  self.effectDict = nil
  self.firstName = nil
  self.bigName = nil
  self.lastName = nil
  self.nickName = nil
  self.tagIds = nil
  self.propertyData = nil
  self.prevPropertyData = nil
  self.propertyGroupedDetailData = nil
  self.weaponInfo = nil
  self.fragId = nil
  self.costCommonFrag = nil
  self.costExclusiveFrag = nil
  self.costSkillPoint = nil
  self.heroType = 0
  self.appearanceMeta = nil
  self.propertyTemplateType = nil
  self.equipUids = nil
  self.equipPower = nil
  self.newUnlockSkillTags = nil
  self.rankLv = nil
  self.honorLevel = nil
  self.maxHonorLevel = nil
  self.fromTemplate = false
  self.uwUnitLvMap = nil
  self.awakenLv = nil
  self.skinId = nil
end

local function UpdateInfo(self, message, isHired)
  if message == nil then
    return
  end
  self.uuid = message.uuid
  if self.uuid == nil then
    self.uuid = message.heroUuid
  end
  if message.heroId ~= nil then
    if self.heroId ~= tonumber(message.heroId) then
      self.meta = nil
    end
    self.heroId = tonumber(message.heroId)
    if self.meta == nil then
      self.meta = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
      if self.meta ~= nil then
        self.quality = self.meta.quality
        self.finalLevel = HeroUtils:GetMaxLevelByQuality(self.quality)
        self.heroType = self.meta.type
        self.heroJob = self.meta.job
        self.firstName = self.meta.name
        self.bigName = self.meta.bigName
        self.nickName = self.meta.nickName
        self.modelId = self.meta.appearance
        self.propertyTemplateType = self.meta.propertyTemplateType
        self.fragId = self.meta.fragId
        self.maxRank = self.meta.maxRank
        self.maxHonorLevel = self.meta.max_honorLevel
      end
    end
  end
  if message.leaderState ~= nil then
    self.state = message.leaderState
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.exp ~= nil then
    self.exp = message.exp
  end
  if message.lev ~= nil then
    self.lastLevel = self.level
    self.level = message.lev
  end
  if message.rankLv ~= nil then
    self.rank = tonumber(message.rankLv)
    self.rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(self.rank)
  end
  if message.weaponInfo then
    local weaponInfo = message.weaponInfo
    if weaponInfo.weaponLevel then
      if self:IsUniqueWeaponOpen() then
        self.uniqueWeaponLv = weaponInfo.weaponLevel
        if self.uniqueWeaponLv > 0 then
          self.weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.uniqueWeaponLv)
          if self.weaponInfo then
            self.modelId = self.weaponInfo.modelId
          end
        end
      else
        self.uniqueWeaponLv = 0
        if weaponInfo.weaponLevel > 0 then
          self.realWeaponLv = weaponInfo.weaponLevel
        end
      end
    end
    if weaponInfo.strengthenState ~= nil then
      self.unlockedEnhanceUW = weaponInfo.strengthenState
    else
      self.unlockedEnhanceUW = false
    end
    if weaponInfo.strengthenArray ~= nil then
      for i = 1, #weaponInfo.strengthenArray do
        local unitInfo = weaponInfo.strengthenArray[i]
        local slot = unitInfo.slot
        local level = unitInfo.level
        if slot ~= nil and level ~= nil then
          self.uwUnitLvMap[slot] = level
        end
      end
    end
  end
  local isOverrideEffData = message.addAction == "HERO_TRAIN_SWAP"
  if isOverrideEffData then
    if self.propertyData then
      self.propertyData:Clear()
    end
    self.effectDict = {}
  end
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  end
  if message.effect ~= nil then
    self:UpdateEffect(message.effect)
  end
  self.skillMaxLvAdd = self:GetProperty(HeroEffectDefine.HeroSkillMaxLevelAdd)
  if message.skills ~= nil then
    self.skillDict = {}
    local prevSkillUnlockStateList
    if self.skillList and next(self.skillList) then
      prevSkillUnlockStateList = {}
      for k, v in pairs(self.skillList) do
        prevSkillUnlockStateList[k] = v:IsUnlock()
      end
    end
    self.skillList = {}
    for _, dt in pairs(message.skills) do
      local skillId = dt.skillId
      local skillData = SkillInfo.New()
      skillData:SetAddMaxLevel(self.skillMaxLvAdd or 0)
      skillData:UpdateSkillInfo(dt)
      self.skillDict[skillId] = skillData
      self.skillList[skillData:GetSlotIndex()] = skillData
      if prevSkillUnlockStateList and skillData:IsUnlock() and not prevSkillUnlockStateList[skillData:GetSlotIndex()] then
        self.newUnlockSkillTags[skillData:GetSlotIndex()] = true
      end
    end
    DataCenter.LWArmedUpgradeManager:UpdateArmedUpgradeSkillInfoData(self)
    prevSkillUnlockStateList = nil
  end
  if message.upSkillNum ~= nil then
    self.upSkillNum = message.upSkillNum
  end
  if message.gender ~= nil then
    self.gender = message.gender
  end
  if message.equipUids ~= nil then
    self.equipUids = message.equipUids
  end
  if message.honorLevel ~= nil then
    self.honorLevel = message.honorLevel
  end
  if not self.appearanceMeta or self.appearanceMeta and self.appearanceMeta.id ~= self.modelId then
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
    if not self.appearanceMeta then
      Logger.LogError("\229\164\150\232\167\130\233\133\141\231\189\174\232\161\168\230\137\190\228\184\141\229\136\176\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.modelId .. ",\232\139\177\233\155\132id:" .. self.heroId)
    end
  end
  if message.awakenLv ~= nil then
    self.awakenLv = message.awakenLv
  end
  if message.heroSkinId ~= nil and message.skinId ~= nil then
    self.skinId = message.skinId
    Logger.LogWarning("HeroInfo.UpdateInfo \230\128\142\228\185\136\229\144\140\230\151\182\229\173\152\229\156\168heroSkinId\229\146\140skinId\239\188\159\231\148\168skinId\228\186\134")
  elseif message.heroSkinId ~= nil then
    self.skinId = message.heroSkinId
  elseif message.skinId ~= nil then
    self.skinId = message.skinId
  end
  self:RefreshHeroPower()
end

local function UpdateEffect(self, effects)
  if self.propertyData ~= nil then
    self.prevPropertyData = DeepCopy(self.propertyData)
  end
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  end
  for k, v in pairs(effects) do
    local effectId = tonumber(k)
    local effectValue = tonumber(v)
    self.effectDict[effectId] = effectValue
    self.propertyData:SetProperty(effectId, effectValue)
  end
  self:RefreshHeroPower()
end

local function CalculateFinalAttri(self)
  local hp = self:GetHeroProperty(HeroEffectDefine.HealthPoint)
  local heroFinalHp = hp * (1 + self:GetHeroProperty(75050) + self:GetHeroProperty(75052) + self:GetHeroProperty(75053) + self:GetHeroProperty(75054) + self:GetHeroProperty(75055) - self:GetHeroProperty(75101) - self:GetHeroProperty(75102) - self:GetHeroProperty(75103)) * (1 + self:GetHeroProperty(75051))
  self.propertyData:SetProperty(50019, heroFinalHp)
  local fianlHp = heroFinalHp
  self.propertyData:SetProperty(HeroEffectDefine.HealPoint_Result, fianlHp)
  local atk = self:GetHeroProperty(HeroEffectDefine.PhysicalAttack)
  local heroFinalAtk = atk * (1 + self:GetHeroProperty(75150) + self:GetHeroProperty(75152) + self:GetHeroProperty(75153) + self:GetHeroProperty(75154) + self:GetHeroProperty(75155) - self:GetHeroProperty(75201) - self:GetHeroProperty(75202) - self:GetHeroProperty(75203)) * (1 + self:GetHeroProperty(75151) - self:GetHeroProperty(75200))
  self.propertyData:SetProperty(50016, heroFinalAtk)
  local fianlAtk = heroFinalAtk
  self.propertyData:SetProperty(HeroEffectDefine.PhysicalAttack_Result, fianlAtk)
  local def = self:GetHeroProperty(HeroEffectDefine.PhysicalDefense)
  local heroFinalDef = def * (1 + self:GetHeroProperty(75250) + self:GetHeroProperty(75252) + self:GetHeroProperty(75253) + self:GetHeroProperty(75254) + self:GetHeroProperty(75255) - self:GetHeroProperty(75301) - self:GetHeroProperty(75302) - self:GetHeroProperty(75303)) * (1 + self:GetHeroProperty(75251) - self:GetHeroProperty(75300))
  self.propertyData:SetProperty(50018, heroFinalDef)
  local fianlDef = heroFinalDef
  self.propertyData:SetProperty(HeroEffectDefine.PhysicalDefense_Result, fianlDef)
end

local function UpdateFromMailData(self, templateId, level, skillList, weaponLv, rank, awakenLv, skinId)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(templateId)
  if heroTemplate == nil then
    return
  end
  self.uuid = 0
  self.heroId = templateId
  self.heroType = heroTemplate.type
  self.heroJob = heroTemplate.job
  self.quality = heroTemplate.quality
  self.meta = heroTemplate
  self.level = level or 1
  self.modelId = heroTemplate.appearance
  self.uniqueWeaponLv = weaponLv or 0
  self.weaponLv = weaponLv or 0
  self.maxRank = heroTemplate.maxRank
  self.rank = rank or 1
  if self.rank > self.maxRank then
    self.rank = self.maxRank
  end
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  else
    self.propertyData:Clear()
  end
  self.awakenLv = awakenLv or 0
  if heroTemplate.heroData_type == HeroTemplateType.Dominator then
    self.rankTemplate = nil
    self.modelId = DataCenter.DominatorTemplateManager:GetAppearanceId(self.heroId, self.rank)
  else
    if 0 < self.rank then
      self.rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(self.rank)
    else
      self.rankTemplate = nil
    end
    self.modelId = heroTemplate.appearance
  end
  if 0 < self.uniqueWeaponLv then
    self.weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.uniqueWeaponLv)
    self.modelId = self.weaponInfo.modelId
    if self.weaponInfo then
      for k, v in pairs(self.weaponInfo.attr) do
        local effectId = tonumber(k)
        local effectValue = tonumber(v)
        self.propertyData:SetProperty(effectId, self:GetProperty(effectId) + effectValue)
      end
    end
  end
  local isAwakened = self:IsHeroAwakened()
  if skinId ~= nil and 0 < skinId then
    self.skinId = skinId
  else
    self.skinId = 0
    if isAwakened then
      local awakenTemplate = self:GetHeroAwakenTemplate()
      if awakenTemplate then
        local isAwakenMax = self:IsHeroAwakenReachMaxLevel()
        self.skinId = isAwakenMax and awakenTemplate.advanced_awaken_skin_id or awakenTemplate.awaken_skin_id
      end
    end
  end
  self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
  self.skillMaxLvAdd = self:GetProperty(HeroEffectDefine.HeroSkillMaxLevelAdd)
  self.skillDict = {}
  self.skillList = {}
  if skillList then
    for k, v in ipairs(skillList) do
      local skillData = SkillInfo.New()
      skillData:SetAddMaxLevel(self.skillMaxLvAdd or 0)
      skillData:CreateFromTemplate(v.skillId, true, v.skillLv)
      local slotIndex = 0
      local safeIndex = IntMaxValue
      if v.slot and 0 < v.slot then
        slotIndex = v.slot
      else
        slotIndex = DataCenter.HeroTemplateManager:GetSlotIndex(v.skillId)
        if not slotIndex then
          slotIndex = safeIndex
          safeIndex = safeIndex - 1
        end
      end
      skillData.slotIndex = slotIndex
      self.skillDict[v.skillId] = skillData
      self.skillList[slotIndex] = skillData
    end
  end
end

function HeroInfo:UpdateFromMailSkills(skillList)
  if skillList then
    for k, v in ipairs(skillList) do
      local skillId = v.skillId
      local skillLv = v.skillLv
      if self.skillDict[skillId] then
        self.skillDict[skillId].level = skillLv
        self.skillDict[skillId].isUnlocked = true
      end
    end
  end
end

local function UpdateFromTemplate(self, templateId, level, rank, skillLevel, weaponLv, skillInfos, awakenLv, skinId)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(templateId)
  if heroTemplate == nil then
    return false
  end
  self.uuid = 0
  self.heroId = templateId
  self.heroType = heroTemplate.type
  self.heroJob = heroTemplate.job
  self.meta = heroTemplate
  self.exp = 0
  self.level = level or 1
  self.quality = heroTemplate.quality
  self.finalLevel = HeroUtils:GetMaxLevelByQuality(self.quality)
  if self.level > self.finalLevel then
    self.level = self.finalLevel
  end
  self.maxRank = heroTemplate.maxRank
  self.rank = rank or 1
  if self.rank > self.maxRank then
    self.rank = self.maxRank
  end
  if heroTemplate.heroData_type == HeroTemplateType.Dominator then
    self.rankTemplate = nil
    self.modelId = DataCenter.DominatorTemplateManager:GetAppearanceId(self.heroId, self.rank)
  else
    if 0 < self.rank then
      self.rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(self.rank)
    else
      self.rankTemplate = nil
    end
    self.modelId = heroTemplate.appearance
  end
  self.firstName = heroTemplate.name
  self.bigName = heroTemplate.bigName
  self.nickName = heroTemplate.nickName
  self.maxHonorLevel = heroTemplate.maxHonorLevel
  self.fragId = heroTemplate.fragId
  self.propertyTemplateType = heroTemplate.propertyTemplateType
  self.honourLevel = 0
  self.awakenLv = awakenLv or 0
  local isAwakened = self:IsHeroAwakened()
  if skinId ~= nil and 0 < skinId then
    self.skinId = skinId
  else
    self.skinId = 0
    if isAwakened then
      local awakenTemplate = self:GetHeroAwakenTemplate()
      if awakenTemplate then
        local isAwakenMax = self:IsHeroAwakenReachMaxLevel()
        self.skinId = isAwakenMax and awakenTemplate.advanced_awaken_skin_id or awakenTemplate.awaken_skin_id
      end
    end
  end
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  else
    self.propertyData:Clear()
  end
  local property = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateByTypeAndLevel(self.propertyTemplateType, self.level, heroTemplate.hpFactor, heroTemplate.atkFactor, heroTemplate.defFactor, heroTemplate.accFactor, heroTemplate.critFactor)
  for k, v in pairs(property) do
    local effectId = tonumber(k)
    local effectValue = tonumber(v)
    self.propertyData:SetProperty(effectId, effectValue)
  end
  self.uniqueWeaponLv = weaponLv or 0
  if 0 < self.uniqueWeaponLv then
    self.weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.uniqueWeaponLv)
    self.modelId = self.weaponInfo.modelId
    if self.weaponInfo then
      for k, v in pairs(self.weaponInfo.attr) do
        local effectId = tonumber(k)
        local effectValue = tonumber(v)
        self.propertyData:SetProperty(effectId, self:GetProperty(effectId) + effectValue)
      end
    end
  end
  self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
  self.skillMaxLvAdd = self:GetProperty(HeroEffectDefine.HeroSkillMaxLevelAdd)
  local attrRatio = 0
  local rankAddHp = 0
  local rankAddDef = 0
  local rankAddAtk = 0
  if self.rankTemplate then
    attrRatio = self.rankTemplate:GetEffectRatio()
    rankAddHp = self.rankTemplate:GetAddEffect(HeroEffectDefine.HealthPoint)
    rankAddDef = self.rankTemplate:GetAddEffect(HeroEffectDefine.PhysicalDefense)
    rankAddAtk = self.rankTemplate:GetAddEffect(HeroEffectDefine.PhysicalAttack)
  end
  local hp = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateHp(self.propertyTemplateType, self.level)
  hp = (hp + rankAddHp) * attrRatio * heroTemplate.hpFactor
  self.propertyData:SetProperty(HeroEffectDefine.HealthPoint, hp)
  local atk = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateAtk(self.propertyTemplateType, self.level)
  atk = (atk + rankAddAtk) * attrRatio * heroTemplate.atkFactor
  self.propertyData:SetProperty(HeroEffectDefine.PhysicalAttack, atk)
  local def = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateDef(self.propertyTemplateType, self.level)
  def = (def + rankAddDef) * attrRatio * heroTemplate.defFactor
  self.propertyData:SetProperty(HeroEffectDefine.PhysicalDefense, def)
  local critDamage = DataCenter.HeroParamDataManager.defaultCriticialDamage
  self.propertyData:SetProperty(HeroEffectDefine.CriticalDamage_Result, critDamage)
  CalculateFinalAttri(self)
  self.skillDict = {}
  self.skillList = {}
  local isUsingSkillInfos = false
  if not table.IsNullOrEmpty(skillInfos) then
    for _, data in pairs(skillInfos) do
      if data.slot and 0 < data.slot then
        isUsingSkillInfos = true
        break
      end
    end
  end
  if isUsingSkillInfos and weaponLv and 0 < weaponLv then
    for _, data in pairs(skillInfos) do
      local skillId = data.skillId
      local realSkillId = tonumber(skillId)
      local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(realSkillId)
      if not skillTemplate then
        break
      end
      local skillData = SkillInfo.New()
      skillData:SetAddMaxLevel(self.skillMaxLvAdd or 0)
      skillData:CreateFromTemplate(realSkillId, true, data.skillLv)
      skillData.slotIndex = data.slot
      self.skillDict[realSkillId] = skillData
      self.skillList[data.slot] = skillData
    end
  else
    local skillIndex = 1
    for _, id in pairs(heroTemplate.skills) do
      local realSkillId = tonumber(id)
      local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(realSkillId)
      local maxStar = skillTemplate.maxStar
      local groupId = skillTemplate.group
      for i = 1, maxStar + 1 do
        local skillId = groupId + i - 1
        local newSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
        if newSkillTemplate ~= nil and not (newSkillTemplate.star > newSkillTemplate.maxStar) then
          if newSkillTemplate.needRank <= self.rank then
            realSkillId = skillId
          elseif newSkillTemplate.needRank > self.rank then
            break
          end
        end
      end
      local skillData = SkillInfo.New()
      local unlockState = false
      local unlockSkillLevel = self:GetSkillUnlockLevelByIndex(skillIndex)
      local needRank = self:GetSkillUnlockRankByIndex(skillIndex)
      unlockState = unlockSkillLevel <= self.level and needRank <= self.rank
      skillData:SetAddMaxLevel(self.skillMaxLvAdd or 0)
      if skillLevel and type(skillLevel) == "table" then
        skillData:CreateFromTemplate(realSkillId, unlockState, skillLevel[realSkillId])
      else
        skillData:CreateFromTemplate(realSkillId, unlockState, skillLevel)
      end
      skillData.slotIndex = skillIndex
      self.skillDict[realSkillId] = skillData
      self.skillList[skillIndex] = skillData
      skillIndex = skillIndex + 1
    end
  end
  self.equipUids = {}
  self:CalculateHeroPower()
  self.fromTemplate = true
  return true
end

local function CreateNewSkillInfoFormRealSkillInfo(self, targetSkillId, realSkillInfo)
  local realSkillId = targetSkillId
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(realSkillId)
  local maxStar = skillTemplate.maxStar
  local groupId = skillTemplate.group
  for i = 1, maxStar + 1 do
    local skillId = groupId + i - 1
    local newSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if newSkillTemplate ~= nil and not (newSkillTemplate.star > newSkillTemplate.maxStar) then
      if newSkillTemplate.needRank <= self.rank then
        realSkillId = skillId
      elseif newSkillTemplate.needRank > self.rank then
        break
      end
    end
  end
  local skillData = SkillInfo.New()
  skillData.slotIndex = realSkillInfo.slotIndex
  skillData.heroUuid = realSkillInfo.heroUuid
  skillData.uuid = realSkillInfo.uuid
  skillData:SetAddMaxLevel(realSkillInfo.addMaxLv)
  skillData:CreateFromTemplate(realSkillId, realSkillInfo.isUnlocked, realSkillInfo.level, realSkillInfo.star)
  return skillData
end

local function ReplaceAppearance(self, appearanceMap)
  local appearanceId = appearanceMap and appearanceMap[self.modelId]
  if appearanceId then
    self.modelId = appearanceId
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
  end
end

local function GetLvUpChangedAttr(self)
  local atkAdd = math.max(0, self.atk - self.lastAtk)
  local defAdd = math.max(0, self.atk - self.lastAtk)
  local preArmy = GetTableData(TableName.NewHeroesLevelUp, self.level - 1, "army_num" .. self.rarity)
  local nowArmy = GetTableData(TableName.NewHeroesLevelUp, self.level, "army_num" .. self.rarity)
  local armyAdd = nowArmy - preArmy
  local powerAdd = math.max(0, self.power - self.lastPower)
  return atkAdd, defAdd, armyAdd, powerAdd
end

local function SetUpSkillNum(self, num)
  self.upSkillNum = num
end

local function GetConfig(self)
  return self.config
end

local function GetCamp(self)
  return self.config.camp
end

local function IsMaxQuality(self)
  local maxQuality = self:GetMaxQuality()
  return maxQuality <= self.quality
end

local function GetConfigQuality(self)
  return self.configQuality
end

local function GetCurMaxLevel(self)
  return self.finalLevel
end

local function IsReachLevelLimit(self)
  local levelLimit = self:GetCurMaxLevel()
  return levelLimit <= self.level
end

local function GetFinalLevel(self)
  return self.finalLevel
end

local function GetAdvanceConsume(self)
  return self.advanceReq
end

local function IsLocked(self)
  return false
end

local function GetBelongFormation(self)
  return nil
end

local function GetResetExp(self)
  return 0, 0, 0
end

local function GetBornDateStr(self)
  local timeStamp = 1626332742000
  local time = timeStamp // 1000
  local format = os.date("!*t", time)
  local format_time = string.format("%d/%d/%d", format.year, format.month, format.day)
  return format_time
end

local function GetAttrByQuality(self, quality, level, rankId)
  quality = quality or self.quality
  level = level or self.level
  rankId = rankId or self.rank
  local beyondTimes = HeroUtils.GetBeyondTimesByLevel(self.curMaxLevel)
  local heroId = self.heroId
  return HeroUtils.GetHeroAttr(heroId, quality, level, beyondTimes, rankId)
end

local function IsInMarch(self)
  return self.state == ArmyFormationState.March
end

local function IsInFormation(self)
  local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  for id, formationData in pairs(formationList) do
    if formationData.state == ArmyFormationState.March then
      local heroes = formationData.heroes
      if table.containsKey(heroes, self.uuid) then
        return true, formationData.index, ArmyFormationState.March
      end
    end
  end
  local patternData = DataCenter.ArmyFormationDataManager:GetFormationFormDataByHeroUuid(self.uuid)
  if patternData ~= nil then
    return true, patternData.index, ArmyFormationState.Free
  end
  return false
end

local function UpdateSkillLevel(self, skillId, level)
  local skill = self.skillDict[skillId]
  if skill == nil then
    return
  end
  skill:SetLevel(level)
end

local function GetNextUnlockSkills(self)
  local level = self.level + 1
  local list = {}
  for _, skill in pairs(self.skillDict) do
    if skill.level == 1 and skill.unlockHeroLv == level then
      table.insert(list, skill.skillId)
    end
  end
  return list
end

local function GetUnlockSkillByLevel(self, level)
  local list = {}
  for _, skill in pairs(self.skillDict) do
    if skill.level == 1 and skill.unlockHeroLv == level then
      table.insert(list, skill.skillId)
    end
  end
  return list
end

local function GetUnlockSkillByQuality(self, quality)
  local list = {}
  return list
end

local UpgradeSkillState = {
  NoUnlockSkill = -1,
  AllSKillReachMax = -2,
  UnlockSkillReachMax = -3,
  CanUpgrade = 0
}

local function HandleEffect(self, effect)
  for k, v in pairs(effect) do
    local effectId = tonumber(k)
    local effectValue = tonumber(v)
    self.effectDict[effectId] = effectValue
  end
end

local function GetSkillData(self, skillId)
  local skillData = self.skillDict[skillId]
  return skillData
end

local function GetSkillLevel(self, skillId)
  local skillData = self.skillDict[skillId]
  if skillData ~= nil then
    return skillData:GetLevel()
  end
  return 0
end

local function GetEffectNum(self, effectId)
  local num = 0
  if self.effectDict[effectId] ~= nil then
    num = self.effectDict[effectId]
  end
  return num
end

local function GetName(self)
  return Localization:GetString(self.firstName)
end

local function GetNickName(self)
  if self:IsHeroAwakened() then
    local awakenTemplate = self:GetHeroAwakenTemplate()
    if awakenTemplate then
      return Localization:GetString(awakenTemplate.new_hero_brief)
    end
  end
  return Localization:GetString(self.nickName)
end

local function GetBigName(self)
  return Localization:GetString(self.bigName)
end

local function HasCultivated(self)
  if self.level > 1 then
    return true
  end
  for _, v in pairs(self.skillDict) do
    if v.level > 1 then
      return true
    end
  end
  return false
end

local function GetUpgradeRankCost(self)
  local curRankId = self:GetRank()
  local maxRankId = self:GetMaxRank()
  if curRankId >= maxRankId then
    return false
  end
  if not self.fragId then
    return false
  end
  if not self.rankTemplate then
    return false
  end
  if self.meta and not string.IsNullOrEmpty(self.meta.hero_promotion_peace_num) then
    return self.rankTemplate.shard_need_promotion
  end
  local costFragNum = self.rankTemplate.shard_need
  return costFragNum
end

local function CanUpgradeToNextStar(self)
  if self:IsReachMaxRank() then
    return false
  end
  if not self.fragId then
    return false
  end
  if not self.rankTemplate then
    return false
  end
  local curRank = self:GetRank()
  local curStar = math.floor((curRank - 1) / 5)
  local nextStarRank = (curStar + 1) * 5 + 1
  local totalNeed = 0
  for rank = curRank, nextStarRank - 1 do
    local rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(rank)
    totalNeed = totalNeed + rankTemplate.shard_need
  end
  local curFragCount = DataCenter.ItemData:GetItemCount(self.fragId)
  return totalNeed <= curFragCount
end

local function GetMaxAvailableRankByFrag(self)
  if not self.rankTemplate or not self.fragId then
    return self.rank
  end
  local curRank = self:GetRank()
  local maxRank = self:GetMaxRank()
  local curFragCount = DataCenter.ItemData:GetItemCount(self.fragId)
  local currentTemplate = self.rankTemplate
  local nextRank = curRank
  while maxRank > nextRank do
    local cost = currentTemplate and currentTemplate.shard_need or 0
    if curFragCount < cost then
      break
    end
    curFragCount = curFragCount - cost
    nextRank = nextRank + 1
    currentTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(nextRank)
  end
  return nextRank
end

local function CanUpMilitaryRank(self)
  local curRankId = self:GetRank()
  local maxRankId = self:GetMaxRank()
  if curRankId >= maxRankId then
    return false
  end
  if not self.fragId then
    return false
  end
  if not self.rankTemplate then
    return false
  end
  local costFragNum = self:GetUpgradeRankCost()
  local fragHave = DataCenter.ItemData:GetItemCount(self.fragId)
  if costFragNum > fragHave then
    return false
  end
  return true
end

local function NeedBeyond(self)
  return self:IsReachBreakLimit()
end

local function CanBeyond(self)
  return false
end

local function ShowUpGradeRedPoint(self, itemExpCount)
  local flag = true
  if self.level >= HeroUtils.GetMaxLevelByQuality(self.heroId, self.quality) then
    return false
  end
  if DataCenter.BuildManager == nil or DataCenter.BuildManager.MainLv == nil then
    return false
  end
  local mainCityHeroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  if mainCityHeroLevelLimit <= self.level then
    return false
  end
  if self.level > self.finalLevel then
    return false
  end
  if flag then
    local totalExp = HeroUtils.GetLevelUpNeedExp(self.level)
    local needExp = totalExp - self.exp
    local costResoruces = HeroUtils.GetLevelUpCostResources(self.level)
    for resourceId, resourceNum in pairs(costResoruces) do
      local cost = resourceNum
      local have = LuaEntry.Resource:GetCntByResType(resourceId)
      if cost > have then
        return false
      end
    end
    if needExp <= 0 then
      return true
    end
    if itemExpCount ~= nil then
      return itemExpCount >= needExp
    else
      local hasExpCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
      return needExp <= hasExpCount
    end
  end
  return false
end

local function GetEquipBySlotType(self, slotType)
  if self.equipUids == nil then
    return nil
  end
  for _, v in pairs(self.equipUids) do
    local equipData = DataCenter.EquipDataManager:GetEquipByUuid(v)
    if equipData ~= nil and equipData.config ~= nil and equipData.config.slot == slotType then
      return equipData
    end
  end
  return nil
end

local function ShowEquipRedPoint(self, onlyReplace)
  if not self:IsUnlockEquipFunction() then
    return false
  end
  for i = 1, 4 do
    local equipPower = 0
    local equip = self:GetEquipBySlotType(i)
    if equip ~= nil then
      if not onlyReplace then
        if equip:CanUpgrade() then
          return true
        end
        if equip:CanPromote() then
          return true
        end
      end
      equipPower = equip.power
    end
    if DataCenter.EquipDataManager:HasBetterEquipBySlotAndHeroType(i, self.heroType, equipPower) then
      return true
    end
  end
  return false
end

local function NeedShowRedPoint(self, itemExpCount)
  return false, nil
end

local function IsReachBreakLimit(self)
  return false
end

local function GetRank(self)
  return self.rank
end

local function GetMaxRank(self)
  return self.maxRank
end

local function IsReachMaxRank(self)
  return self.rank >= self.maxRank
end

local function IsUnlockHonorWall(self)
  return self:IsReachMaxRank() or self.honorLevel > 0
end

local function IsHonorLockState(self)
  return self.honorLevel > 0 and not self:IsReachMaxRank()
end

local function IsSkillCanUpgrade(self, skillData)
  if not skillData:IsUnlock() then
    return false
  end
  if skillData:IsReachMaxLevel() then
    return false
  end
  local costId = DataCenter.HeroParamDataManager.heroSkillPointItemId
  local costCount = skillData:GetUpgradeCostSkillPoint()
  local skillPointCount = DataCenter.ResourceItemDataManager:GetCountByItemId(costId)
  if costCount > skillPointCount then
    return false
  end
  return true
end

local function GetCanUpgradeSkill(self)
  for _, skillData in pairs(self.skillDict) do
    if skillData ~= nil and self:IsSkillCanUpgrade(skillData) then
      return skillData
    end
  end
  return nil
end

local function IsSkillMax(self, skillId)
  if not self:IsSkillUnlock(skillId) then
    return false
  end
  local skillData = self.skillDict[skillId]
  if skillData == nil then
    return false
  end
  local maxLv = GetTableData(TableName.SkillTab, skillId, "level")
  return skillData.level >= toInt(maxLv)
end

local function IsAllSkillReachMaxLevel(self)
  for _, skillData in pairs(self.skillDict) do
    if skillData ~= nil and not skillData:IsReachMaxLevel() then
      return false
    end
  end
  return true
end

local function IsSkillUnlock(self, skillId)
  local skillData = self.skillDict[skillId]
  if skillData == nil then
    return false
  end
  return skillData.level > 0
end

local function IsWakeUp(self)
  return false
end

local function GetSkillPower(self)
  local result = 0
  table.walk(self.skillDict, function(k, v)
    if self:IsSkillUnlock(k) then
      local strPos = GetTableData(TableName.SkillTab, k, "power")
      if not string.IsNullOrEmpty(strPos) then
        local vec = string.split(strPos, "|")
        if table.count(vec) >= v.level then
          result = result + toInt(vec[v.level])
        end
      end
    end
  end)
  return result
end

local function IsAllOpenSkillCanUpgrade(self)
  local needNum = 0
  local costMedalId = self.config.skill_levelup_item
  local costMedalNum = self.config.skill_levelup_num
  local currentNum = DataCenter.ItemData:GetItemCount(costMedalId)
  table.walk(self.skillDict, function(k, v)
    if self:IsSkillCanUpgrade(k) then
      local itemNeed = costMedalNum[v.level]
      if itemNeed > needNum then
        needNum = itemNeed
      end
    end
  end)
  return needNum <= currentNum and 0 < needNum
end

local function CanUpgradeStar(self)
  if HeroUtils.IsReachStarLimit(self) then
    return false
  end
  local needNum = HeroUtils.GetHeroStarCostByHeroData(self)
  local upgradeItemId = HeroUtils.GetHeroDebrisIdByHeroId(self.heroId)
  local hasNum = DataCenter.ItemData:GetItemCount(upgradeItemId)
  return needNum <= hasNum
end

local function GetHeroProperty(self, propertyType)
  if self.propertyData == nil then
    return 0
  end
  return self.propertyData:GetProperty(propertyType)
end

local function GetProperty(self, propertyType)
  if self.propertyData == nil then
    return 0
  end
  return self.propertyData:GetProperty(propertyType)
end

local function GetAllProperty(self)
  if self.propertyData == nil then
    return nil
  end
  return self.propertyData:GetAllProperty()
end

local function GetHeroPrevProperty(self, propertyType)
  if self.prevPropertyData == nil then
    return 0
  end
  return self.prevPropertyData:GetProperty(propertyType)
end

local function GetHeroFragId(self)
  return self.fragId
end

local function GetHeroSkillBySlotIndex(self, slotIndex)
  if self.skillList == nil then
    return nil
  end
  if self.skillList[slotIndex] then
    return self.skillList[slotIndex]
  end
  return nil
end

function HeroInfo:GetSkillList()
  return self.skillList
end

local function GetHeroSkillBySkillId(self, skillId)
  if self.skillDict == nil then
    return nil
  end
  local result
  if self.skillDict[skillId] ~= nil then
    result = self.skillDict[skillId]
  end
  return result
end

local function GetAllUnlockSkills(self)
  local ret = {}
  for _, v in pairs(self.skillDict) do
    if v.isUnlocked then
      table.insert(ret, v)
    end
  end
  return ret
end

local function GetAllUnlockSkillsExcludeUltimate(self)
  local ret = {}
  for _, v in pairs(self.skillDict) do
    if v.isUnlocked and not v:IsUltimateSkill() then
      table.insert(ret, v)
    end
  end
  return ret
end

local function GetUltimateSkill(self)
  if self.skillDict == nil then
    return nil
  end
  for k, v in pairs(self.skillDict) do
    if v:IsUltimateSkill() then
      return v
    end
  end
end

local function GetAllSkills(self)
  return DeepCopy(self.skillDict)
end

local function GetAllSkillsReadOnly(self)
  return self.skillDict
end

local function CanUnlockSkillByPrevSkillLimit(self, skillSlotIndex)
  if not table.containsKey(self.skillList, skillSlotIndex) then
    return false
  end
  if skillSlotIndex <= 1 then
    return true
  end
  local prevSkill = self.skillList[skillSlotIndex - 1]
  if prevSkill == nil then
    return false
  end
  return prevSkill:IsUnlock()
end

local function GetMaxHp(self)
  return math.floor(self:GetHeroProperty(HeroEffectDefine.HealPoint_Result))
end

local function GetAtk(self)
  return math.floor(self:GetHeroProperty(HeroEffectDefine.PhysicalAttack_Result))
end

function HeroInfo:GetSoldierCapacity()
  return math.floor(self:GetHeroProperty(HeroEffectDefine.HeroSoldierCapacity))
end

local function GetDef(self)
  return math.floor(self:GetHeroProperty(HeroEffectDefine.PhysicalDefense_Result))
end

local function CalculateHeroPower(self)
  local hpFactor = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(HeroEffectDefine.HealthPoint).power
  local atkFactor = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(HeroEffectDefine.PhysicalAttack).power
  local defFactor = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(HeroEffectDefine.PhysicalDefense).power
  local critRateFactor = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(HeroEffectDefine.CriticalRate_Result).power
  local critDamageFactor = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(HeroEffectDefine.CriticalDamage_Result).power
  local hitRateFactor = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(HeroEffectDefine.ChanceToHit_Result).power
  local propertyPower = self.propertyData:GetProperty(HeroEffectDefine.HealthPoint) * hpFactor
  propertyPower = propertyPower + self.propertyData:GetProperty(HeroEffectDefine.PhysicalAttack) * atkFactor
  propertyPower = propertyPower + self.propertyData:GetProperty(HeroEffectDefine.PhysicalDefense) * defFactor
  propertyPower = propertyPower + self.propertyData:GetProperty(HeroEffectDefine.CriticalRate_Result) * critRateFactor
  propertyPower = propertyPower + self.propertyData:GetProperty(HeroEffectDefine.CriticalDamage_Result) * critDamageFactor
  propertyPower = propertyPower + self.propertyData:GetProperty(HeroEffectDefine.ChanceToHit_Result) * hitRateFactor
  propertyPower = math.floor(propertyPower)
  local skillPower = 0
  for id, skillData in pairs(self.skillDict) do
    if skillData:IsUnlock() then
      skillPower = skillPower + skillData:GetPower()
    end
  end
  local equipPower = 0
  if self.equipUids ~= nil then
    for _, uuid in pairs(self.equipUids) do
      local equipData = DataCenter.EquipDataManager:GetEquipByUuid(uuid)
      if equipData ~= nil then
        equipPower = equipPower + equipData.power
      end
    end
  end
  skillPower = math.floor(skillPower)
  local power = propertyPower + skillPower + equipPower
  if self.power ~= power then
    self.lastPower = self.power
  end
  self.power = power
  self.propertyPower = propertyPower
  self.skillPower = skillPower
  self.equipPower = equipPower
end

local function RefreshHeroPower(self)
  local power = math.floor(self:GetProperty(HeroEffectDefine.HeroPower))
  local propertyPower = math.floor(self:GetProperty(HeroEffectDefine.HeroPowerLevel))
  local skillPower = math.floor(self:GetProperty(HeroEffectDefine.HeroPowerSkill))
  local equipPower = math.floor(self:GetProperty(HeroEffectDefine.HeroPowerEquip))
  if self.power ~= power then
    self.lastPower = self.power
  end
  self.power = power
  self.propertyPower = propertyPower
  self.skillPower = skillPower
  self.equipPower = equipPower
end

local function IsUnlockEquipFunction(self)
  local reachShowEquipBtnLimit = true
  local heroLevelLimit = DataCenter.HeroParamDataManager.equipHeroLevelLimit
  if heroLevelLimit > self.level then
    reachShowEquipBtnLimit = false
  end
  local qualityLimit = DataCenter.HeroParamDataManager.equipHeroQualityLimit
  if qualityLimit >= self.quality then
    reachShowEquipBtnLimit = false
  end
  local mainCityLevelLimit = DataCenter.HeroParamDataManager.equipMainCityLevelLimit
  if mainCityLevelLimit > DataCenter.BuildManager.MainLv then
    reachShowEquipBtnLimit = false
  end
  return reachShowEquipBtnLimit
end

local function ShowSkillRedPoint(self)
  for i = 1, 4 do
    local skillData = self:GetHeroSkillBySlotIndex(i)
    if skillData ~= nil and self:IsSkillCanUpgrade(skillData) then
      return true
    end
  end
  return false
end

local function GetEquipProperty(self, effectId)
  if table.IsNullOrEmpty(self.equipUids) then
    return 0
  end
  local value = 0
  for _, uuid in pairs(self.equipUids) do
    local equipData = DataCenter.EquipDataManager:GetEquipByUuid(uuid)
    if equipData ~= nil then
      value = value + equipData:GetProperty(effectId)
    end
  end
  return value
end

local function GetSkillUnlockLevelByIndex(self, index)
  local skillUnlockLevels = self.meta.skills_unlock_lv
  if not table.IsNullOrEmpty(skillUnlockLevels) then
    if skillUnlockLevels[index] then
      return skillUnlockLevels[index]
    end
  else
    return 0
  end
end

local function IsIndexSkillNewUnlocked(self, index)
  local newTag = self.newUnlockSkillTags[index]
  if newTag and newTag == true then
    return true
  end
end

local function MarkNewUnlockedSkillRead(self, index)
  self.newUnlockSkillTags[index] = nil
end

local function GetLevelUnlockSkill(self)
  local newUnlockSkills = {}
  for slotIndex, skillData in pairs(self.skillList) do
    if skillData:IsUnlock() then
      local skillUnlockLevel = self:GetSkillUnlockLevelByIndex(slotIndex)
      local skillUnlockRank = self:GetSkillUnlockRankByIndex(slotIndex)
      if self.level == skillUnlockLevel and skillUnlockRank <= self.rank then
        table.insert(newUnlockSkills, skillData)
      end
    end
  end
  return newUnlockSkills
end

local function GetRankUnlockSkill(self)
  local newUnlockSkills = {}
  for slotIndex, skillData in pairs(self.skillList) do
    if skillData:IsUnlock() then
      local skillUnlockLevel = self:GetSkillUnlockLevelByIndex(slotIndex)
      local skillUnlockRank = self:GetSkillUnlockRankByIndex(slotIndex)
      if self.rank == skillUnlockRank and skillUnlockLevel <= self.level then
        table.insert(newUnlockSkills, skillData)
      end
    end
  end
  return newUnlockSkills
end

local function SetSkillPageRedPoint(self)
  self.unlockNewSkill = true
end

local function GetSkillPageRedPoint(self)
  if self.unlockNewSkill then
    return self.unlockNewSkill
  end
  return false
end

local function MarkSkillPageRedPoint(self)
  self.unlockNewSkill = false
end

local function GetAtkFactor(self)
  if self.meta then
    return self.meta.atkFactor
  else
    return 0
  end
end

local function GetDefFactor(self)
  if self.meta then
    return self.meta.defFactor
  else
    return 0
  end
end

local function GetHpFactor(self)
  if self.meta then
    return self.meta.hpFactor
  else
    return 0
  end
end

local function GetBuildingAdditionByType(self, type, effects)
  local function getEffVal(effId, heroInfo, effects)
    if effects then
      return math.floor(effects[effId] or 0)
    else
      return math.floor(heroInfo:GetEffectNum(effId) or 0)
    end
  end
  
  if self.heroType == HeroType.Tank then
    if type == HeroicForceType.Life then
      return getEffVal(HeroEffectDefine.TankBuildingLastLife, self, effects)
    elseif type == HeroicForceType.Attack then
      return getEffVal(HeroEffectDefine.TankBuildingLastAttack, self, effects)
    elseif type == HeroicForceType.Defence then
      return getEffVal(HeroEffectDefine.TankBuildingLastDefence, self, effects)
    elseif type == HeroicForceType.SoldierCapacity then
      return getEffVal(HeroEffectDefine.TankBuildingLastSoldierCapacity, self, effects) + getEffVal(HeroEffectDefine.AllBuildingLastSoldierCapacity, self, effects)
    end
  elseif self.heroType == HeroType.Missile then
    if type == HeroicForceType.Life then
      return getEffVal(HeroEffectDefine.MissileBuildingLastLife, self, effects)
    elseif type == HeroicForceType.Attack then
      return getEffVal(HeroEffectDefine.MissileBuildingLastAttack, self, effects)
    elseif type == HeroicForceType.Defence then
      return getEffVal(HeroEffectDefine.MissileBuildingLastDefence, self, effects)
    elseif type == HeroicForceType.SoldierCapacity then
      return getEffVal(HeroEffectDefine.MissileBuildingLastSoldierCapacity, self, effects) + getEffVal(HeroEffectDefine.AllBuildingLastSoldierCapacity, self, effects)
    end
  elseif self.heroType == HeroType.Aircraft then
    if type == HeroicForceType.Life then
      return getEffVal(HeroEffectDefine.AircraftBuildingLastLife, self, effects)
    elseif type == HeroicForceType.Attack then
      return getEffVal(HeroEffectDefine.AircraftBuildingLastAttack, self, effects)
    elseif type == HeroicForceType.Defence then
      return getEffVal(HeroEffectDefine.AircraftBuildingLastDefence, self, effects)
    elseif type == HeroicForceType.SoldierCapacity then
      return getEffVal(HeroEffectDefine.AircraftBuildingLastSoldierCapacity, self, effects) + getEffVal(HeroEffectDefine.AllBuildingLastSoldierCapacity, self, effects)
    end
  end
end

local function IsReachMaxHonorLevel(self)
  return self.honorLevel >= self.maxHonorLevel
end

local function GetHonorLevelUpgradeCost(self)
  local key
  if self.meta and not string.IsNullOrEmpty(self.meta.hero_promotion_peace_num) then
    key = "shard_need_promotion"
  else
    key = "shard_need"
  end
  return GetTableData(TableName.LW_Hero_HonorLevel, self.honorLevel, key) or 0
end

local function CollectHonorEffect(self)
  if not self.meta then
    return {}
  end
  local honorEffects = self.meta.honor_level_effects
  local unlockEffects = {}
  for level, effects in pairs(honorEffects) do
    if level <= self.honorLevel then
      for id, value in pairs(effects) do
        if not unlockEffects[id] then
          unlockEffects[id] = 0
        end
        unlockEffects[id] = unlockEffects[id] + value
      end
    end
  end
  return unlockEffects
end

local function IsHonorLevelUnlock(self)
  local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[self.heroType])
  local functionUnlock = typeBuilding ~= nil and typeBuilding.level >= functionUnlockLevel
  return functionUnlock and self:IsReachMaxRank()
end

local function GetSkillUnlockRankByIndex(self, index)
  local skillUnlockRanks = self.meta.skills_unlock_rank
  if not table.IsNullOrEmpty(skillUnlockRanks) then
    if skillUnlockRanks[index] then
      return skillUnlockRanks[index]
    end
  else
    return 0
  end
end

local function GetHeroCommonFragId(self)
  if self.meta then
    return self.meta.hero_promotion_peace_num
  end
end

local function HasUniqueWeapon(self)
  return self.uniqueWeaponLv > 0
end

function HeroInfo:IsUniqueWeaponShow()
  if not self.meta then
    return false
  end
  return self.meta:IsUnqueWeaponShow()
end

function HeroInfo:IsUniqueWeaponOpen()
  if not self.meta then
    return false
  end
  if not self:IsUniqueWeaponShow() then
    return false
  end
  local showNeedRankId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k3", 0)
  if showNeedRankId > self.rank then
    return false
  end
  return true
end

function HeroInfo:IsUniqueWeaponLockState()
  return self.realWeaponLv and self.realWeaponLv > 0 and not self:IsUniqueWeaponOpen()
end

function HeroInfo:IsUniqueWeaponMaxLevel()
  if not self.meta then
    return
  end
  return self.uniqueWeaponLv >= self.meta:GetUniqueWeaponMaxLv()
end

function HeroInfo:GetUniqueWeaponInfo()
  return self.weaponInfo
end

function HeroInfo:GetUniqueWeaponLv()
  return self.uniqueWeaponLv
end

function HeroInfo:GetUniqueWeaponRealLv()
  return self.realWeaponLv
end

function HeroInfo:GetSkillBySkillGroupId(groupId)
  if self.skillDict == nil then
    return nil
  end
  local result
  for _, v in pairs(self.skillDict) do
    if v:GetGroupId() == groupId then
      result = v
      break
    end
  end
  return result
end

function HeroInfo:CheckCanUpgradeUniqueWeapon()
  if not self:IsUniqueWeaponOpen() then
    return false
  end
  if self:IsUniqueWeaponMaxLevel() then
    return false
  end
end

function HeroInfo:GetRankRatio()
  if self.rankTemplate then
    return self.rankTemplate.attr_ratio
  end
  return 0
end

function HeroInfo:ProcessEffectValue(id, value)
  if not value then
    return 0
  end
  if not id then
    return value
  end
  if id == HeroEffectDefine.UniqueWeaponHp or id == HeroEffectDefine.UniqueWeaponAtk or id == HeroEffectDefine.UniqueWeaponDef or id == HeroEffectDefine.HeroSkillMaxLevelAdd then
    if id == HeroEffectDefine.HeroSkillMaxLevelAdd then
      local maxLv = 0
      for i = 1, 3 do
        local skillData = self:GetHeroSkillBySlotIndex(i)
        if skillData and not skillData:IsFocused() and maxLv < skillData.skillTemplateData.maxLevel then
          maxLv = skillData.skillTemplateData.maxLevel
          break
        end
      end
      return maxLv + value
    else
      local heroRankRatio = self:GetRankRatio()
      local hpFactor = 1
      local atkFactor = 1
      local defFactor = 1
      if self.meta then
        hpFactor = self.meta.hpFactor
        atkFactor = self.meta.atkFactor
        defFactor = self.meta.defFactor
      end
      if id == HeroEffectDefine.UniqueWeaponHp then
        value = value * heroRankRatio * hpFactor
      elseif id == HeroEffectDefine.UniqueWeaponAtk then
        value = value * heroRankRatio * atkFactor
      elseif id == HeroEffectDefine.UniqueWeaponDef then
        value = value * heroRankRatio * defFactor
      end
      return value
    end
  else
    return value
  end
end

function HeroInfo:CanShowUniqueWeaponRedPoint()
  if self:IsUniqueWeaponOpen() then
    if self:IsUniqueWeaponMaxLevel() then
      if self:CanShowUWEnhanceRedPoint() then
        return true
      else
        return false
      end
    end
    local nextLvTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.uniqueWeaponLv + 1)
    if nextLvTemplate then
      local costs = nextLvTemplate:GetCosts()
      for itemId, itemNum in pairs(costs) do
        local itemId = itemId
        local itemNum = itemNum
        local haveNum = DataCenter.ItemData:GetItemCount(itemId)
        if itemNum > haveNum then
          return false
        end
      end
    end
    return true
  end
  return false
end

function HeroInfo:IsUniqueWeaponNewOpen()
  if self.hasOpenedUniqueWeapon then
    return false
  end
  local isUniqueWeaponShow = self:IsUniqueWeaponShow()
  if isUniqueWeaponShow then
    local oepnRecordStr = string.format(SettingKeys.HERO_UNIQUE_WEAPON_OPEN, self.heroId)
    local hasOpen = Setting:GetPrivateBool(oepnRecordStr, false)
    if hasOpen then
      self.hasOpenedUniqueWeapon = true
      return false
    else
      return true
    end
  end
  return false
end

function HeroInfo:GetAdditionLevelSoldierCapacity()
  if self.heroType == HeroType.Tank then
    return self:GetEffectNum(HeroEffectDefine.TankLevelSoldierCapacity)
  elseif self.heroType == HeroType.Missile then
    return self:GetEffectNum(HeroEffectDefine.MissileLevelSoldierCapacity)
  elseif self.heroType == HeroType.Aircraft then
    return self:GetEffectNum(HeroEffectDefine.AircraftLevelSoldierCapacity)
  end
  return 0
end

function HeroInfo:ShowHeroStory()
  if string.IsNullOrEmpty(self.meta.backstory_desc) then
    return false
  end
  return self.meta:CheckTemplateBackStoryCanShow()
end

function HeroInfo:IsRealDominator()
  if self.meta then
    return self.meta.heroData_type == HeroTemplateType.Dominator
  end
  return false
end

function HeroInfo:GetHeroUWFragId()
  local template = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, 1)
  if not template then
    return 0
  end
  for fragId, num in pairs(template:GetCosts()) do
    return fragId
  end
  return 0
end

function HeroInfo:IsUWUnitMaxLv(type)
  local isUnitMaxLv = false
  if self.uwUnitLvMap and self.uwUnitLvMap[type] then
    local maxLv = DataCenter.HeroUWEnhanceTemplateManager:GetMaxLevel(self.heroId, type)
    isUnitMaxLv = maxLv <= self.uwUnitLvMap[type]
  end
  return isUnitMaxLv
end

function HeroInfo:GetUWUnitLv(type)
  return self.uwUnitLvMap[type] or 0
end

function HeroInfo:GetUnitUpgradeInfo(type)
  local isMaxLv = self:IsUWUnitMaxLv(type)
  if isMaxLv then
    return nil
  end
  local curLv = self:GetUWUnitLv(type)
  curLv = curLv or 0
  return DataCenter.HeroUWEnhanceTemplateManager:GetUpgradeInfo(type, curLv + 1)
end

function HeroInfo:GetUnitUpgradeCost(type)
  local upgradeInfo = self:GetUnitUpgradeInfo(type)
  if not upgradeInfo then
    return 0
  end
  local costNum = upgradeInfo.cost
  return self:GetHeroUWFragId(), costNum
end

function HeroInfo:GetUniqueWeaponEnhanceAttr(type, level)
  local allAttr = 0
  local allValue = 0
  local selfAttr = 0
  local selfValue = 0
  allAttr, allValue, selfAttr, selfValue = DataCenter.HeroUWEnhanceTemplateManager:GetCurrentLevelAttr(self.heroId, type, level)
  return allAttr, allValue, selfAttr, selfValue
end

function HeroInfo:GetNextUnlockSelfAttr(type, level)
  return DataCenter.HeroUWEnhanceTemplateManager:GetNextUnlockSelfAttr(self.heroId, type, level)
end

function HeroInfo:IsUnlockedEnhanceUW()
  return self.unlockedEnhanceUW
end

function HeroInfo:CanUnlockEnhanceUW()
  if not self:IsUniqueWeaponMaxLevel() then
    return false
  end
  local uwEnhanceTemplate = DataCenter.HeroUWEnhanceTemplateManager:GetHeroUWUnitTemplate(self.heroId, 1)
  if not uwEnhanceTemplate then
    return false
  end
  return true
end

function HeroInfo:UnlockEnhanceUW()
  self.unlockedEnhanceUW = true
end

function HeroInfo:UpdateUWUnitInfo(units)
  self.uwUnitLvMap = {}
  for i, v in ipairs(units) do
    self.uwUnitLvMap[v.slot] = v.lv
  end
end

function HeroInfo:CanShowUWEnhanceRedPoint()
  if not self:IsUniqueWeaponOpen() then
    return false
  end
  if not self:IsUnlockedEnhanceUW() then
    return self:CanUnlockEnhanceUW()
  end
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    if self:CanShowUWEnhanceRedPointForUnit(i) then
      return true
    end
  end
  return false
end

function HeroInfo:CanUpgradeForUWUnit(type)
  local upgradeInfo = self:GetUnitUpgradeInfo(type)
  if not upgradeInfo then
    return false, false
  end
  local condition = upgradeInfo.unitCondition
  for _, v in ipairs(condition) do
    local unitLv = self:GetUWUnitLv(v.type)
    if unitLv < v.level then
      return false, false
    end
  end
  local fragId = self:GetHeroUWFragId()
  local costNum = upgradeInfo.cost
  if fragId and costNum then
    local haveNum = DataCenter.ItemData:GetItemCount(fragId)
    if costNum > haveNum then
      return true, false
    end
  end
  return true, true
end

function HeroInfo:CanShowUWEnhanceRedPointForUnit(type)
  local isMaxLv = self:IsUWUnitMaxLv(type)
  if isMaxLv then
    return false
  end
  local canUpgrade, hasEnough = self:CanUpgradeForUWUnit(type)
  if canUpgrade and hasEnough then
    return true
  end
  return false
end

function HeroInfo:GetAllUnitLvSum()
  local sum = 0
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    sum = sum + self:GetUWUnitLv(i)
  end
  return sum
end

function HeroInfo:IsAllUnitMaxLv()
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    if not self:IsUWUnitMaxLv(i) then
      return false
    end
  end
  return true
end

function HeroInfo:GetAllUWAttrs()
  local attrs = {}
  if not self:IsUniqueWeaponOpen() then
    return attrs
  end
  local weaponInfo = self:GetUniqueWeaponInfo()
  if weaponInfo then
    local weaponAttrs = weaponInfo:GetAttrs()
    for k, v in pairs(weaponAttrs) do
      attrs[k] = self:ProcessEffectValue(k, v)
    end
  end
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    local uwEnhanceTemplate = DataCenter.HeroUWEnhanceTemplateManager:GetHeroUWUnitTemplate(self.heroId, i)
    if uwEnhanceTemplate then
      local uwEnhanceAttrs = uwEnhanceTemplate:GetAllAttrs(self:GetUWUnitLv(i))
      for k, v in pairs(uwEnhanceAttrs) do
        attrs[k] = self:ProcessEffectValue(k, v)
      end
    end
  end
  attrs[HeroEffectDefine.UniqueWeaponHp_result] = attrs[HeroEffectDefine.UniqueWeaponHp] + attrs[HeroEffectDefine.UniqueWeaponHp_UW_Unit_Self]
  attrs[HeroEffectDefine.UniqueWeaponAtk_result] = attrs[HeroEffectDefine.UniqueWeaponAtk] + attrs[HeroEffectDefine.UniqueWeaponAtk_UW_Unit_Self]
  attrs[HeroEffectDefine.UniqueWeaponDef_result] = attrs[HeroEffectDefine.UniqueWeaponDef] + attrs[HeroEffectDefine.UniqueWeaponDef_UW_Unit_Self]
  return attrs
end

local BUILD_SC_EFFECTS = {
  [50071] = true,
  [50072] = true,
  [50073] = true,
  [50074] = true
}

function HeroInfo:CalcHeroSCSource()
  local def = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateSc(self.propertyTemplateType, self.level)
  local levelVal = math.floor(def)
  local buildingEffects = BuildingUtils.GetEffectFromBuildings(BUILD_SC_EFFECTS)
  local decorationEffects = BuildingUtils.GetEffectFromDecorations(BUILD_SC_EFFECTS)
  local tempEffects = {}
  for k, v in pairs(buildingEffects) do
    tempEffects[k] = v
  end
  for k, v in pairs(decorationEffects) do
    tempEffects[k] = (tempEffects[k] or 0) + v
  end
  local survivorEffects = WorkerUtil.GetEffectValue(BUILD_SC_EFFECTS)
  local survivorVal = self:GetBuildingAdditionByType(HeroicForceType.SoldierCapacity, survivorEffects)
  local buildVal = self:GetBuildingAdditionByType(HeroicForceType.SoldierCapacity, tempEffects)
  local sciVal = self:GetAdditionLevelSoldierCapacity()
  sciVal = math.floor(sciVal)
  levelVal = math.max(levelVal, 0)
  survivorVal = math.max(survivorVal, 0)
  buildVal = math.max(buildVal, 0)
  sciVal = math.max(sciVal, 0)
  return levelVal, survivorVal, buildVal, sciVal
end

function HeroInfo:IsHeroAwakenOpen()
  return DataCenter.HeroAwakenDataManager:IsHeroAwakenOpenByHeroInfo(self)
end

function HeroInfo:GetHeroAwakenRankLevel()
  return self.awakenLv
end

function HeroInfo:IsHeroAwakenCanUpgrade(checkUserItemCount)
  if checkUserItemCount == nil then
    checkUserItemCount = false
  end
  if not DataCenter.HeroAwakenDataManager:IsHeroAwakenCanUpgradeByHeroInfo(self) then
    return false
  end
  if checkUserItemCount then
    if self:IsHeroAwakenReachMaxLevel() then
      return false
    end
    if self:IsHeroAwakenReachTmpLimit() then
      return false
    end
    local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroId, true)
    if not awakenTemplate then
      return false
    end
    local curAwakenLv = self:GetHeroAwakenRankLevel() or 0
    local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroId, curAwakenLv)
    if not rankTemplate then
      return false
    end
    if not self:IsHeroAwakened() then
      local costItemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
      local costItemCount = rankTemplate:GetRankUpgradeCostItemCount()
      local haveItemCount = DataCenter.ItemData:GetItemCount(costItemId)
      if costItemCount <= haveItemCount then
        return true
      end
    else
      local costItemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
      local costItemCount = rankTemplate:GetRankUpgradeCostItemCount()
      local haveItemCount = DataCenter.ItemData:GetItemCount(costItemId)
      if costItemCount <= haveItemCount then
        return true
      end
      local commonItemId = HeroUtils.GetHeroAwakenRankUpgradeCommonCostItemId()
      local commonHaveCount = 0
      if commonItemId and 0 < commonItemId then
        commonHaveCount = DataCenter.ItemData:GetItemCount(commonItemId)
        local commonCostCount = costItemCount - haveItemCount
        if commonHaveCount >= commonCostCount then
          return true
        end
      end
    end
    return false
  end
  return true
end

function HeroInfo:IsHeroAwakened()
  local awakenLv = self:GetHeroAwakenRankLevel()
  return 1 <= awakenLv
end

function HeroInfo:GetHeroAwakenRankTemplate()
  local awakenLv = self:GetHeroAwakenRankLevel()
  return DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroId, awakenLv)
end

function HeroInfo:GetHeroAwakenTemplate()
  return DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroId)
end

function HeroInfo:IsHeroAwakenReachMaxLevel()
  if not self:IsHeroAwakened() then
    return false
  end
  local maxRank = self:GetHeroAwakenMaxLevel()
  local curRank = self:GetHeroAwakenRankLevel()
  return maxRank <= curRank
end

function HeroInfo:IsHeroAwakenReachTmpLimit()
  if self:IsHeroAwakened() then
    local curLv = self:GetHeroAwakenRankLevel()
    return 15 <= curLv
  end
  return false
end

function HeroInfo:GetHeroAwakenMaxLevel()
  local awakenTemplate = self:GetHeroAwakenTemplate()
  if not awakenTemplate then
    return 0
  end
  return awakenTemplate:GetHeroAwakenMaxRankLevel()
end

function HeroInfo:GetSkinId()
  if self:IsHeroAwakened() then
    return self.skinId
  end
  return 0
end

function HeroInfo:IsHeroAwakenNewOpen()
  if self.hasOpenedHeroAwaken then
    return false
  end
  local isHeroAwakenShow = self:IsHeroAwakenOpen()
  if isHeroAwakenShow then
    local oepnRecordStr = string.format(SettingKeys.HERO_AWAKEN_OPEN, self.heroId)
    local hasOpen = Setting:GetPrivateBool(oepnRecordStr, false)
    if hasOpen then
      self.hasOpenedHeroAwaken = true
      return false
    else
      return true
    end
  end
  return false
end

function HeroInfo:CanShowHeroAwakenRedPoint()
  if self:IsHeroAwakenOpen() then
    return self:IsHeroAwakenCanUpgrade(true)
  end
  return false
end

function HeroInfo:GetHeroAwakenSkill()
  local skill = self:GetHeroSkillBySlotIndex(HERO_AWAKEN_SKILL_SLOT_INDEX)
  if skill and skill:IsHeroAwakenSkill() then
    return skill
  end
  return nil
end

function HeroInfo:UpdatePropertyGroupedDetailData(detailArray)
  if self.propertyGroupedDetailData == nil then
    self.propertyGroupedDetailData = HeroPropertyGroupedDetailData.New()
  end
  self.propertyGroupedDetailData:UpdateData(detailArray)
end

function HeroInfo:GetPropertyGroupedDetailData()
  return self.propertyGroupedDetailData
end

function HeroInfo:GetHeroModelData(modelType)
  return HeroUtils.GetHeroModelData(self.heroId, modelType, self:GetUniqueWeaponLv(), self:GetSkinId(), self:GetRank())
end

HeroInfo.__init = __init
HeroInfo.__delete = __delete
HeroInfo.UpdateInfo = UpdateInfo
HeroInfo.UpdateFromTemplate = UpdateFromTemplate
HeroInfo.UpdateFromMailData = UpdateFromMailData
HeroInfo.ReplaceAppearance = ReplaceAppearance
HeroInfo.GetConfig = GetConfig
HeroInfo.GetCamp = GetCamp
HeroInfo.IsMaxQuality = IsMaxQuality
HeroInfo.GetConfigQuality = GetConfigQuality
HeroInfo.GetCurMaxLevel = GetCurMaxLevel
HeroInfo.IsReachLevelLimit = IsReachLevelLimit
HeroInfo.GetFinalLevel = GetFinalLevel
HeroInfo.CanUpgradeStar = CanUpgradeStar
HeroInfo.GetAdvanceConsume = GetAdvanceConsume
HeroInfo.IsLocked = IsLocked
HeroInfo.GetBelongFormation = GetBelongFormation
HeroInfo.GetResetExp = GetResetExp
HeroInfo.GetLvUpChangedAttr = GetLvUpChangedAttr
HeroInfo.GetBornDateStr = GetBornDateStr
HeroInfo.GetAttrByQuality = GetAttrByQuality
HeroInfo.IsInMarch = IsInMarch
HeroInfo.IsInFormation = IsInFormation
HeroInfo.UpdateSkillLevel = UpdateSkillLevel
HeroInfo.GetNextUnlockSkills = GetNextUnlockSkills
HeroInfo.GetUnlockSkillByQuality = GetUnlockSkillByQuality
HeroInfo.SetUpSkillNum = SetUpSkillNum
HeroInfo.HandleEffect = HandleEffect
HeroInfo.GetSkillData = GetSkillData
HeroInfo.GetSkillLevel = GetSkillLevel
HeroInfo.GetEffectNum = GetEffectNum
HeroInfo.GetName = GetName
HeroInfo.GetBigName = GetBigName
HeroInfo.GetNickName = GetNickName
HeroInfo.HasCultivated = HasCultivated
HeroInfo.IsReachBreakLimit = IsReachBreakLimit
HeroInfo.NeedShowRedPoint = NeedShowRedPoint
HeroInfo.CanUpMilitaryRank = CanUpMilitaryRank
HeroInfo.CanBeyond = CanBeyond
HeroInfo.NeedBeyond = NeedBeyond
HeroInfo.GetRank = GetRank
HeroInfo.GetMaxRank = GetMaxRank
HeroInfo.IsReachMaxRank = IsReachMaxRank
HeroInfo.IsSkillUnlock = IsSkillUnlock
HeroInfo.IsWakeUp = IsWakeUp
HeroInfo.GetUnlockSkillByLevel = GetUnlockSkillByLevel
HeroInfo.GetCanUpgradeSkill = GetCanUpgradeSkill
HeroInfo.IsSkillCanUpgrade = IsSkillCanUpgrade
HeroInfo.GetSkillPower = GetSkillPower
HeroInfo.IsAllOpenSkillCanUpgrade = IsAllOpenSkillCanUpgrade
HeroInfo.IsSkillMax = IsSkillMax
HeroInfo.ShowUpGradeRedPoint = ShowUpGradeRedPoint
HeroInfo.GetHeroProperty = GetHeroProperty
HeroInfo.GetHeroPrevProperty = GetHeroPrevProperty
HeroInfo.GetHeroFragId = GetHeroFragId
HeroInfo.GetHeroSkillBySlotIndex = GetHeroSkillBySlotIndex
HeroInfo.GetHeroSkillBySkillId = GetHeroSkillBySkillId
HeroInfo.GetAllSkills = GetAllSkills
HeroInfo.GetAllSkillsReadOnly = GetAllSkillsReadOnly
HeroInfo.GetAllUnlockSkills = GetAllUnlockSkills
HeroInfo.GetAllUnlockSkillsExcludeUltimate = GetAllUnlockSkillsExcludeUltimate
HeroInfo.GetUltimateSkill = GetUltimateSkill
HeroInfo.CanUnlockSkillByPrevSkillLimit = CanUnlockSkillByPrevSkillLimit
HeroInfo.GetMaxHp = GetMaxHp
HeroInfo.GetAtk = GetAtk
HeroInfo.GetDef = GetDef
HeroInfo.CalculateHeroPower = CalculateHeroPower
HeroInfo.RefreshHeroPower = RefreshHeroPower
HeroInfo.GetEquipBySlotType = GetEquipBySlotType
HeroInfo.ShowEquipRedPoint = ShowEquipRedPoint
HeroInfo.IsUnlockEquipFunction = IsUnlockEquipFunction
HeroInfo.ShowSkillRedPoint = ShowSkillRedPoint
HeroInfo.GetProperty = GetProperty
HeroInfo.GetEquipProperty = GetEquipProperty
HeroInfo.GetSkillUnlockLevelByIndex = GetSkillUnlockLevelByIndex
HeroInfo.IsIndexSkillNewUnlocked = IsIndexSkillNewUnlocked
HeroInfo.MarkNewUnlockedSkillRead = MarkNewUnlockedSkillRead
HeroInfo.GetUpgradeRankCost = GetUpgradeRankCost
HeroInfo.GetMaxAvailableRankByFrag = GetMaxAvailableRankByFrag
HeroInfo.GetLevelUnlockSkill = GetLevelUnlockSkill
HeroInfo.SetSkillPageRedPoint = SetSkillPageRedPoint
HeroInfo.GetSkillPageRedPoint = GetSkillPageRedPoint
HeroInfo.MarkSkillPageRedPoint = MarkSkillPageRedPoint
HeroInfo.GetAtkFactor = GetAtkFactor
HeroInfo.GetDefFactor = GetDefFactor
HeroInfo.GetHpFactor = GetHpFactor
HeroInfo.GetBuildingAdditionByType = GetBuildingAdditionByType
HeroInfo.UpdateEffect = UpdateEffect
HeroInfo.IsReachMaxHonorLevel = IsReachMaxHonorLevel
HeroInfo.GetHonorLevelUpgradeCost = GetHonorLevelUpgradeCost
HeroInfo.CollectHonorEffect = CollectHonorEffect
HeroInfo.IsHonorLevelUnlock = IsHonorLevelUnlock
HeroInfo.GetSkillUnlockRankByIndex = GetSkillUnlockRankByIndex
HeroInfo.GetRankUnlockSkill = GetRankUnlockSkill
HeroInfo.GetHeroCommonFragId = GetHeroCommonFragId
HeroInfo.HasUniqueWeapon = HasUniqueWeapon
HeroInfo.IsAllSkillReachMaxLevel = IsAllSkillReachMaxLevel
HeroInfo.GetAllProperty = GetAllProperty
HeroInfo.IsUnlockHonorWall = IsUnlockHonorWall
HeroInfo.IsHonorLockState = IsHonorLockState
HeroInfo.CreateNewSkillInfoFormRealSkillInfo = CreateNewSkillInfoFormRealSkillInfo
HeroInfo.CanUpgradeToNextStar = CanUpgradeToNextStar
return HeroInfo
