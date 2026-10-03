local TacticalCardData = BaseClass("TacticalCardData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.uuid = ""
  self.cardId = 0
  self.level = 0
  self.star = 0
  self.slotId = 0
  self.cardTmpData = nil
  self.randomAttr = nil
  self.skillInfoDic = {}
  self.calculatedPower = nil
end

local function __delete(self)
  self.uuid = nil
  self.cardId = nil
  self.level = nil
  self.star = nil
  self.slotId = nil
  self.cardTmpData = nil
  self.randomAttr = nil
  self.skillInfoDic = nil
end

function TacticalCardData:UpdateData(serverData)
  if not serverData then
    Logger.LogError("card server data is nil")
    return
  end
  self.uuid = serverData.uuid
  self.cardId = serverData.cardId
  self.cardTmpData = DataCenter.TacticalCardDataManager:GetTemplateData(self.cardId)
  self.cardTypeGroup = -1
  self.cardType = TacticalCardType.Core
  if self.cardTmpData then
    self.cardType = self.cardTmpData.type
    self.cardTypeGroup = self.cardTmpData.card_group
    self.lvGroup = self.cardTmpData.lvGroup
  end
  self.slotType = self.cardType
  self:UpdateLevel(serverData.level)
  self:UpdateStar(serverData.star)
  self:UpdateSlot(serverData.slot)
  self:UpdateRandomAttr(serverData.randomAttr)
  self:UpdateSkillInfo(serverData.skillArray)
end

function TacticalCardData:UpdateLevel(value)
  self.level = value
end

function TacticalCardData:UpdateStar(value)
  self.star = value
end

function TacticalCardData:UpdateSlot(value)
  self.slotId = value
end

function TacticalCardData:UpdateRandomAttr(attrs)
  if not attrs then
    return
  end
  self.randomAttr = {}
  for _, attrInfo in ipairs(attrs) do
    local val = math.floor(attrInfo.val * 10000 + 0.5) / 10000
    local effectTemplate = DataCenter.TacticalCardDataManager:GetRandomAttributeShowTemplate(attrInfo.effectId)
    local quality = effectTemplate:GetQuality(val)
    table.insert(self.randomAttr, {
      id = attrInfo.effectId,
      value = val,
      effectName = effectTemplate.effect_name,
      quality = quality
    })
  end
  table.sort(self.randomAttr, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    return a.id > b.id
  end)
end

function TacticalCardData:IsEquip()
  return self.slotId and self.slotId > 0
end

function TacticalCardData:GetEquipSlot()
  return self.slotId
end

function TacticalCardData:IsInCd()
  return self:IsAnySkillInCd()
end

function TacticalCardData:IsAnySkillInCd()
  if not self.skillInfoDic then
    return false
  end
  for _, v in pairs(self.skillInfoDic) do
    local skillData = v
    local isActiveSkill = skillData:GetSkillType() == TacticalCardSkillType.Active
    if isActiveSkill and skillData:GetChargeData() and not skillData:GetChargeData():IsFullCharge() then
      return true
    end
  end
  return false
end

function TacticalCardData:UpdateSkillInfo(skillServerDataList)
  if not self.cardTmpData or not self.cardTmpData.skill then
    return
  end
  local allSkillIdList = TacticalCardUtil.QuickGetCardSkills(self.cardId, self.star, self.level)
  if not allSkillIdList then
    return
  end
  local serverDataDic = {}
  if skillServerDataList then
    for _, v in ipairs(skillServerDataList) do
      serverDataDic[v.skillId] = v
    end
  end
  local tmp = {}
  for _, skillId in ipairs(allSkillIdList) do
    tmp[skillId] = true
    local skillTmp = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillId)
    if skillTmp then
      local skillGroup = skillTmp.group
      local skillServerData = serverDataDic[skillGroup]
      local skillData = self.skillInfoDic[skillId]
      if not skillData then
        skillData = TacticalCardUtil.CreateSkillClass(skillTmp)
        skillData:InitData(self.uuid)
        self.skillInfoDic[skillId] = skillData
      end
      skillData:UpdateData(skillId, skillServerData)
    end
  end
  for skillId, _ in pairs(self.skillInfoDic) do
    if not tmp[skillId] then
      self.skillInfoDic[skillId] = nil
    end
  end
end

local function GetCardTemplate(self)
  if not self._template then
    self._template = DataCenter.TacticalCardDataManager:GetTemplateData(self.cardId)
  end
  if self._template == nil then
    Logger.LogError("\232\191\153\233\135\140\230\152\175\228\184\128\228\184\170nil\229\128\188\239\188\140 cardId:" .. tostring(self.cardId))
  end
  return self._template
end

local function GetStarTemplate(self)
  if self:GetCardType() ~= TacticalCardType.Core then
    return nil
  end
  if self:GetStar() <= 0 then
    return nil
  end
  local starCardId = TacticalCardUtil.GetCardStarRealId(self.cardId, self.star)
  return DataCenter.TacticalCardDataManager:GetStarTemplateData(starCardId)
end

function TacticalCardData:GetCardId()
  return self.cardId
end

function TacticalCardData:GetLevel()
  return self.level
end

function TacticalCardData:GetLvGroup()
  return self.lvGroup or 0
end

function TacticalCardData:GetStar()
  return self.star
end

function TacticalCardData:GetCardTypeGroup()
  return self.cardTypeGroup > 0, self.cardTypeGroup
end

function TacticalCardData:GetMaxStar()
  return self.template.max_star or 0
end

function TacticalCardData:GetCardType()
  return self.template.type
end

function TacticalCardData:GetCardQuality()
  return self.template.color or 0
end

function TacticalCardData:IsCoreCard()
  return self:GetCardType() == TacticalCardType.Core
end

function TacticalCardData:IsMaxStar()
  if not self.template then
    return true
  end
  return self:GetStar() >= self.template.max_star
end

function TacticalCardData:IsMaxLv()
  if not self.template then
    return true
  end
  return self:GetLevel() >= self:GetMaxLv()
end

function TacticalCardData:GetMaxLv()
  if not self.template then
    return 1
  end
  local extraLv = self:GetRandomEffectValue(TacticalCardUtil.Effect_Card_Upgrade)
  extraLv = math.floor(extraLv + 0.5)
  local maxLv = self.template.max_lv + extraLv
  return maxLv
end

function TacticalCardData:GetLvUpgradeCost()
  if self:IsMaxLv() then
    return nil, nil
  end
  local level = self.level
  local lvUpgradeValue = self:GetRandomEffectValue(TacticalCardUtil.Effect_Card_Upgrade)
  if lvUpgradeValue then
    level = level - math.floor(lvUpgradeValue + 0.5)
  end
  local itemId, itemCnt = TacticalCardUtil.GetCardUpgradeCost(self:GetCardType(), self.template.color, level, self:GetLvGroup())
  return itemId, itemCnt
end

function TacticalCardData:GetStarUpgradeCost()
  if self:IsMaxStar() then
    return nil, nil
  end
  local cardId, cnt = TacticalCardUtil.GetCardStarUpgradeCost(self.cardId, self.star)
  return cardId, cnt
end

function TacticalCardData:GetBaseAttrs(lv, star)
  lv = lv or self.level
  star = star or self.star
  return TacticalCardUtil.GetBaseAttrs(self.cardId, lv, star)
end

function TacticalCardData:GetBaseAttrsSorted()
  local baseAttrs = self:GetBaseAttrs()
  local sortedAttrs = {}
  local orders = {}
  for attrId, value in pairs(baseAttrs) do
    local attr = {id = attrId, value = value}
    table.insert(sortedAttrs, attr)
    local order = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(attrId)
    orders[attrId] = order
  end
  table.sort(sortedAttrs, function(a, b)
    return orders[a.id] < orders[b.id]
  end)
  return sortedAttrs
end

function TacticalCardData:GetNextLvBaseAttrs()
  return TacticalCardUtil.GetNextLvBaseAttrs(self.cardId, self.level, self.star, self:GetMaxLv())
end

function TacticalCardData:GetNextStarBaseAttrs()
  return TacticalCardUtil.GetNextStarBaseAttrs(self.cardId, self.level, self.star)
end

function TacticalCardData:GetRandomAttrs()
  return self.randomAttr
end

function TacticalCardData:GetRandomAttrsSorted()
  local randomAttrs = self:GetRandomAttrs()
  local sortedAttrs = {}
  local orders = {}
  if not randomAttrs then
    return sortedAttrs
  end
  for i, attrInfo in ipairs(randomAttrs) do
    local effectTemplate = DataCenter.TacticalCardDataManager:GetRandomAttributeShowTemplate(attrInfo.id)
    local quality = effectTemplate:GetQuality(attrInfo.value)
    table.insert(sortedAttrs, {
      id = attrInfo.id,
      value = attrInfo.value,
      effectName = effectTemplate.effect_name,
      quality = quality
    })
  end
  table.sort(sortedAttrs, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    return a.id > b.id
  end)
  return sortedAttrs
end

function TacticalCardData:GetAllAttrs()
  local baseAttrs = self:GetBaseAttrs()
  local randomAttrs = self:GetRandomAttrs()
  local allAttrs = {}
  for attrId, value in pairs(baseAttrs) do
    allAttrs[attrId] = value
  end
  for _, attrInfo in ipairs(randomAttrs) do
    allAttrs[attrInfo.id] = attrInfo.value + (allAttrs[attrInfo.id] or 0)
  end
  return allAttrs
end

function TacticalCardData:GetRandomEffectValue(effectId)
  local value = 0
  local randomAttrs = self:GetRandomAttrs()
  if randomAttrs and 0 < #randomAttrs then
    for i, v in ipairs(randomAttrs) do
      if v and v.id == effectId then
        value = value + v.value
      end
    end
  end
  return value
end

function TacticalCardData:GetSkillList()
  return TacticalCardUtil.GetCardSkills(self.cardId, self.star, self.level)
end

function TacticalCardData:GetNextStarSkillList()
  return TacticalCardUtil.GetNextStarSkills(self.cardId, self.star)
end

function TacticalCardData:GetPassiveSkillList(containNextValue)
  return TacticalCardUtil.GetCardPassiveSkills(self.cardId, self.level, self.star, containNextValue)
end

function TacticalCardData:GetAllSkillDataList(skillType)
  local ret = {}
  for _, v in pairs(self.skillInfoDic) do
    if not skillType or v:GetSkillType() == skillType then
      table.insert(ret, v)
    end
  end
  return ret
end

function TacticalCardData:GetPower()
  local lv = self:GetLevel()
  local star = self:GetStar()
  if self.calculatedPower and self.cachedPowerAttr and self.cachedPowerAttr.lv == lv and self.cachedPowerAttr.star == star then
    return self.calculatedPower
  end
  local power = self.template.basePower or 0
  if 1 <= lv then
    power = power + lv * self.template.upPower
  end
  if self:IsCoreCard() and 0 < star then
    local starTemplate = self.starTemplate
    if starTemplate then
      power = power + starTemplate.power
    end
  else
    local randomAttr = self.randomAttr
    if randomAttr then
      for _, attrInfo in ipairs(randomAttr) do
        power = power + attrInfo.value * DataCenter.EffectNumberTemplateManager:GetEffectNumberExtraPower(attrInfo.id)
      end
    end
  end
  if not self.cachedPowerAttr then
    self.cachedPowerAttr = {lv = 0, star = 0}
  end
  self.cachedPowerAttr.lv = lv
  self.cachedPowerAttr.star = star
  self.calculatedPower = math.floor(power)
  return self.calculatedPower
end

function TacticalCardData:IsCanBeMaterial()
  return not self:IsEquip() and self:GetStar() == 0
end

function TacticalCardData:GetSortWeightByIndex(index)
  if self.template and index and 0 < index then
    return DataCenter.TacticalCardDataManager:GetQuickEquipSortWeight(self.template, index)
  end
  return 0
end

function TacticalCardData:GetDeck()
  if self.template and self.template.deck ~= nil then
    return self.template.deck
  end
  return TacticalCardUtil.CommonDeck
end

local DEFAULT_COLOR_STR = "#099b4a"
local DEFAULT_HYPER_TEXT_COLOR = "#c47920"

function TacticalCardData:GetBaseSkillDesc(color, hyperTextColor)
  local index = self.level
  if self:IsCoreCard() then
    index = self:GetStar() + 1
  end
  local desc, params = self.template:GetBaseSkillDesc(index)
  return self:GetBaseSkillDescFormat(desc, params, color, hyperTextColor)
end

function TacticalCardData:GetBaseSkillUpgradeDesc(color, hyperTextColor)
  local index = self.level
  local max = self:GetMaxLv()
  if self:IsCoreCard() then
    index = self:GetStar() + 1
    max = self:GetMaxStar() + 1
  end
  if index >= max then
    return self:GetBaseSkillDesc(color, hyperTextColor)
  end
  local desc, params = self.template:GetBaseSkillUpgradeDesc(index)
  return self:GetBaseSkillDescFormat(desc, params, color, hyperTextColor)
end

function TacticalCardData:GetBaseSkillDescFormat(desc, params, color, hyperTextColor)
  if string.IsNullOrEmpty(desc) then
    return
  end
  local colorStr = DEFAULT_COLOR_STR
  if color then
    colorStr = color
  end
  local hyperTextColorStr = DEFAULT_HYPER_TEXT_COLOR
  if hyperTextColor then
    hyperTextColorStr = hyperTextColor
  end
  local resultStr
  if params and 0 < #params then
    local colorParams = {}
    for i, v in ipairs(params) do
      if not string.IsNullOrEmpty(v) then
        colorParams[i] = string.format("<color=%s>%s</color>", colorStr, v)
      end
    end
    resultStr = Localization:GetString(desc, SafeUnpack(colorParams))
  else
    resultStr = Localization:GetString(desc)
  end
  return HeroUtils.ProcessHyperText(resultStr, hyperTextColorStr)
end

function TacticalCardData:IsUseNewSkillDesc()
  if not self.template then
    return false
  end
  return self.template:IsUseNewSkillDesc()
end

function TacticalCardData:GetRealLevel()
  local level = self.level
  local lvUpgradeValue = self:GetRandomEffectValue(TacticalCardUtil.Effect_Card_Upgrade)
  if lvUpgradeValue then
    level = level - math.floor(lvUpgradeValue + 0.5)
  end
  return level
end

TacticalCardData.__init = __init
TacticalCardData.__delete = __delete
TacticalCardData.getters.template = GetCardTemplate
TacticalCardData.getters.starTemplate = GetStarTemplate
return TacticalCardData
