local TacticalChipManager = BaseClass("TacticalChipManager")
local LevelTemplate = require("DataCenter.TacticalWeapon.TacticalChipManager.LwDroneBattlesystemLevelTemplate")
local TierTemplate = require("DataCenter.TacticalWeapon.TacticalChipManager.LwDroneBattlesystemTierTemplate")
local Localization = CS.GameEntry.Localization
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local TIER_MAX = 6
local PLAN_DEFAULT_NAME = "battlesystem_chip_set_name%s"
local CHIP_POS_ICON_PATH = "Assets/Main/Sprites/UI/LWUITacticalWeaponChipCommon/FX_wurenjixingpian_XQ_weizhi0%s.png"
local BATTLE_SYSTEM_PREVIEWING_DISPLAY_CONFIG = "battlesystem_previewing_display_config"
local PLAN_NUM_LIMIT = 4
local ItemType = {Goods = 1, Chip = 2}

function TacticalChipManager:__init()
  self.lvTemplateDic = {}
  self.tierTemplateDic = {}
  self.oldLv = 0
  self.newLv = 0
end

function TacticalChipManager:__delete()
  self:ClearUpgradeFeedCache()
  self.lvTemplateDic = nil
  self.tierTemplateDic = {}
  self.tierTemplateList = nil
  self.oldLv = nil
  self.newLv = nil
end

function TacticalChipManager:OnMessageUpgrade(message)
  if message == nil then
    return
  end
  if message.oldLv then
    self.oldLv = message.oldLv
  end
  if message.newLv then
    self.newLv = message.newLv
  end
  if message.weapon then
    self:ClearUpgradeFeedCache()
    DataCenter.TacticalWeaponManager:UpdateWeapon(message.weapon)
  end
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  self:OnStageUpgradeCheck()
end

function TacticalChipManager:OnStageUpgradeCheck()
  if self.oldLv and self.newLv and self.newLv > self.oldLv then
    local originConfig = self:GetLevelTemplate(self.oldLv)
    local newConfig = self:GetLevelTemplate(self.newLv)
    if originConfig and newConfig and originConfig.system_tier ~= newConfig.system_tier then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponChipStageUpgrade, {anim = true}, originConfig.system_tier, newConfig.system_tier)
    end
  end
end

function TacticalChipManager:GetChipInfo(uuid)
  return DataCenter.TWSkillChipManager:GetChipInfo(uuid)
end

function TacticalChipManager:ClearUpgradeFeedCache()
  self.upgradeFeedData = nil
end

function TacticalChipManager:SetUpgradeFeedCache(dic, totalExp)
  if not self.upgradeFeedData then
    self.upgradeFeedData = {}
  end
  self.upgradeFeedData.propsDic = dic
  self.upgradeFeedData.totalExp = totalExp
end

function TacticalChipManager:GetUpgradeFeedCache()
  return self.upgradeFeedData
end

function TacticalChipManager:GetFeedUseCountCache(type, uuid)
  if self.upgradeFeedData == nil then
    return 0
  end
  local dic = self.upgradeFeedData.propsDic[type]
  if dic == nil or dic[uuid] == nil then
    return 0
  end
  return dic[uuid].useCount
end

function TacticalChipManager:GetFeedTotalExpCache()
  if self.upgradeFeedData == nil then
    return 0
  end
  return self.upgradeFeedData.totalExp
end

function TacticalChipManager:GetUpgradeFeedChipsCache()
  if self.upgradeFeedData and self.upgradeFeedData.propsDic[ItemType.Chip] then
    return self.upgradeFeedData.propsDic[ItemType.Chip]
  end
  return {}
end

function TacticalChipManager:GetUpgradeFeedGoodsCache()
  if self.upgradeFeedData and self.upgradeFeedData.propsDic[ItemType.Goods] then
    return self.upgradeFeedData.propsDic[ItemType.Goods]
  end
  return {}
end

function TacticalChipManager:GetPreLvByUpgradeFeedCache(level, exp)
  local feedData = self:GetUpgradeFeedCache()
  if feedData == nil or feedData.totalExp == 0 then
    return level, exp
  end
  local lvTemplate = self:GetLevelTemplate(level)
  local resultExp = exp + feedData.totalExp
  local nextLv = level
  if resultExp >= lvTemplate.exp_cost then
    local residueExp = resultExp
    repeat
      residueExp = residueExp - lvTemplate.exp_cost
      nextLv = nextLv + 1
      lvTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(nextLv)
    until residueExp < lvTemplate.exp_cost or DataCenter.TacticalChipManager:IsMaxLevel(nextLv)
    resultExp = residueExp
  end
  return nextLv, resultExp
end

function TacticalChipManager:GetUpgradeFeedListCache()
  local feedData = self:GetUpgradeFeedCache()
  if feedData == nil or feedData.totalExp == 0 then
    return nil
  end
  local list = {}
  for i, v in pairs(feedData.propsDic[ItemType.Goods]) do
    if v and 0 < v.useCount then
      table.insert(list, v)
    end
  end
  for i, v in pairs(feedData.propsDic[ItemType.Chip]) do
    if v and 0 < v.useCount then
      table.insert(list, v)
    end
  end
  return list
end

function TacticalChipManager:AddUpgradeFeedCache(itemInfo)
  if itemInfo == nil then
    return
  end
  if not self.upgradeFeedData then
    self.upgradeFeedData = {}
    self.upgradeFeedData.propsDic = {}
    self.upgradeFeedData.propsDic[ItemType.Chip] = {}
    self.upgradeFeedData.propsDic[ItemType.Goods] = {}
    self.upgradeFeedData.totalExp = 0
  end
  local target = self.upgradeFeedData.propsDic[itemInfo.type][itemInfo.uuid]
  if target == nil then
    target = itemInfo
    target.useCount = 0
  end
  local originExp = self.upgradeFeedData.totalExp
  target.useCount = math.min(target.maxCount, target.useCount + 1)
  self.upgradeFeedData.totalExp = originExp + target.addExp
  self.upgradeFeedData.propsDic[itemInfo.type][itemInfo.uuid] = target
  local newExp = self.upgradeFeedData.totalExp
  return originExp, newExp
end

function TacticalChipManager:SubUpgradeFeedCache(itemInfo)
  if itemInfo == nil then
    return
  end
  if self.upgradeFeedData == nil or self.upgradeFeedData.propsDic == nil or self.upgradeFeedData.propsDic[itemInfo.type] == nil or self.upgradeFeedData.propsDic[itemInfo.type][itemInfo.uuid] == nil then
    return
  end
  local target = self.upgradeFeedData.propsDic[itemInfo.type][itemInfo.uuid]
  target.useCount = target.useCount - 1
  self.upgradeFeedData.propsDic[itemInfo.type][itemInfo.uuid] = target
  if target.useCount <= 0 then
    self.upgradeFeedData.propsDic[itemInfo.type][itemInfo.uuid] = nil
  end
  local originExp = self.upgradeFeedData.totalExp
  self.upgradeFeedData.totalExp = math.max(self.upgradeFeedData.totalExp - target.addExp, 0)
  local newExp = self.upgradeFeedData.totalExp
  return originExp, newExp
end

function TacticalChipManager:CheckCanUpgrade()
  local isMaxLv = self:IsMaxLevel(self:GetLevel())
  if isMaxLv then
    return false
  end
  local expItems = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_135)
  if expItems then
    for _, v in pairs(expItems) do
      return true
    end
  end
  local allChips = DataCenter.TWSkillChipManager:GetAllChips()
  for i, v in pairs(allChips) do
    if v and v:IsFree() and not self:NotRecommendedFeed(v:GetUUID()) then
      return true
    end
  end
  return false
end

function TacticalChipManager:GenerateUpgradeFeedAuto()
  local dic = {}
  dic[ItemType.Chip] = {}
  dic[ItemType.Goods] = {}
  local totalExp = 0
  local expItems = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_135)
  if expItems then
    for _, v in pairs(expItems) do
      local itemInfo = self:GetChipFeedInfo(v.uuid, v, ItemType.Goods, v.count, v.para1)
      itemInfo.configId = v.itemId
      totalExp = totalExp + itemInfo.addExp * itemInfo.maxCount
      dic[ItemType.Goods][v.uuid] = itemInfo
    end
  end
  local allChips = DataCenter.TWSkillChipManager:GetAllChips()
  for i, v in pairs(allChips) do
    if v and v:IsFree() and not self:NotRecommendedFeed(v:GetUUID()) then
      local itemInfo = self:GetChipFeedInfo(v.uuid, v, ItemType.Chip, v:GetNum(), v:GetExpOnFeed())
      itemInfo.configId = v:GetId()
      totalExp = totalExp + itemInfo.maxCount * itemInfo.addExp
      dic[ItemType.Chip][itemInfo.uuid] = itemInfo
    end
  end
  if self.upgradeFeedData == nil then
    self.upgradeFeedData = {}
  end
  self.upgradeFeedData.propsDic = dic
  self.upgradeFeedData.totalExp = totalExp
  return totalExp
end

function TacticalChipManager:GetUpgradeProps()
  local resultList = {}
  local expItems = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_135)
  for _, v in ipairs(expItems) do
    local itemInfo = self:GetChipFeedInfo(v.uuid, v, ItemType.Goods, v.count, v.para1)
    itemInfo.configId = v.itemId
    itemInfo.useCount = self:GetFeedUseCountCache(ItemType.Goods, itemInfo.uuid)
    table.insert(resultList, itemInfo)
  end
  local chipList = DataCenter.TWSkillChipManager:GetAllChips()
  for _, v in pairs(chipList) do
    if v:IsFree() and v:GetQuality() < 5 then
      local itemInfo = self:GetChipFeedInfo(v:GetUUID(), v, ItemType.Chip, v:GetNum(), v:GetExpOnFeed())
      itemInfo.configId = v:GetId()
      itemInfo.useCount = self:GetFeedUseCountCache(ItemType.Chip, itemInfo.uuid)
      table.insert(resultList, itemInfo)
    end
  end
  return self:GetSortUpgradeProps(resultList)
end

function TacticalChipManager:GetPlanChips(planId)
  return DataCenter.TWSkillChipManager:GetChipsByMasterSet(planId)
end

function TacticalChipManager:GetPlanSameChipList(chipConfigId)
  local chips = {}
  for i = 1, PLAN_NUM_LIMIT do
    local plan = self:GetPlanChips(i)
    if plan then
      for _, v in pairs(plan) do
        if v and v:GetId() == chipConfigId then
          table.insert(chips, {planId = i, chip = v})
        end
      end
    end
  end
  return chips
end

function TacticalChipManager:GetBestStarChip(chipConfigId)
  local chip
  local allChips = DataCenter.TWSkillChipManager:GetAllChips()
  for i, v in pairs(allChips) do
    if v and v:GetId() == chipConfigId and (chip == nil or v:GetStar() > chip:GetStar()) then
      chip = v
    end
  end
  return chip
end

function TacticalChipManager:GetSortUpgradeProps(list)
  if 1 < #list then
    table.sort(list, function(a, b)
      if a.type ~= b.type then
        return a.type < b.type
      end
      if a.type == ItemType.Goods and a.data and b.data then
        return a.data.goods.quality < b.data.goods.quality
      end
      if a.type == ItemType.Chip then
        if a.data:GetQuality() ~= b.data:GetQuality() then
          return a.data:GetQuality() < b.data:GetQuality()
        end
        if a.data:GetLevel() ~= b.data:GetLevel() then
          return a.data:GetLevel() < b.data:GetLevel()
        end
        if a.data:GetType() ~= b.data:GetType() then
          return a.data:GetType() < b.data:GetType()
        end
        if a.data:GetId() ~= b.data:GetId() then
          return a.data:GetId() < b.data:GetId()
        end
      end
      return a.data.uuid < b.data.uuid
    end)
  end
  return list
end

function TacticalChipManager:HasChipByPosType(posType)
  local dic = DataCenter.TWSkillChipManager:GetChipsByType(posType)
  if dic == nil then
    return false
  end
  local index = 0
  for i, v in pairs(dic) do
    if v and v:IsFree() then
      index = 1
      break
    end
  end
  return 0 < index
end

function TacticalChipManager:IsFunctionTabShow()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local previewTime = DataCenter.TWSkillChipManager:GetChipPreviewTime()
  return now > previewTime
end

function TacticalChipManager:IsFunctionChipPlanTabShow()
  local isChipOpen = self:IsFunctionOpen()
  local limitLv = DataCenter.TacticalChipManager:GetPlanUnlockLevel(1)
  return isChipOpen and limitLv <= self:GetLevel(), limitLv
end

function TacticalChipManager:IsFunctionOpen()
  return DataCenter.TWSkillChipManager:IsFunctionUnlock()
end

function TacticalChipManager:IsMaxLevel(level)
  return self:GetLevelTemplate(level + 1) == nil
end

function TacticalChipManager:IsMaxTier(tier)
  return tier >= TIER_MAX
end

function TacticalChipManager:IsChipFeed(info)
  return info.type == ItemType.Chip
end

function TacticalChipManager:IsPlanUnlock(planIndex)
  local curUnlockIndex = 1
  local systemLevel = 1
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo ~= nil then
    curUnlockIndex = weaponInfo:GetUnlockChipGroup()
    systemLevel = weaponInfo.chipLv
  end
  if planIndex > curUnlockIndex then
    local unlockLevel = self:GetPlanUnlockLevel(planIndex)
    if unlockLevel == nil then
      Logger.LogError("unlockLevel not find! planIndex is " .. tostring(planIndex))
      return false
    end
    return systemLevel >= unlockLevel
  end
  return true
end

function TacticalChipManager:GetStatsAttributeList(level)
  local lvTemplate = self:GetLevelTemplate(level)
  local tierTemplate = self:GetTierTemplate(lvTemplate.system_tier)
  local list = {}
  for k, v in pairs(lvTemplate.level_attribute) do
    if v then
      local attribute = {}
      local effectConfig = DataCenter.EffectNumberTemplateManager:GetTemplate(k)
      attribute.title = Localization:GetString(effectConfig.name)
      attribute.value = math.floor(v)
      table.insert(list, attribute)
    end
  end
  if tierTemplate.effectId and tierTemplate.effectId > 0 then
    local attribute = {}
    local effectConfig = DataCenter.EffectNumberTemplateManager:GetTemplate(tierTemplate.effectId)
    attribute.title = Localization:GetString(effectConfig.name)
    local scienceAdd = LuaEntry.Effect:GetGameEffect(50232)
    local effectValue = tierTemplate.effectValue + scienceAdd
    local describe, text = WorkerUtil.GetEffectText(tierTemplate.effectId, effectValue, true)
    attribute.value = text
    table.insert(list, attribute)
  end
  return list
end

function TacticalChipManager:GetPlanDefaultName(planId)
  local name = "battlesystem_chip_set_name4"
  local color = Color32.New(95, 239, 135, 255)
  local heroTypeCount = {}
  heroTypeCount[1] = 0
  heroTypeCount[2] = 0
  heroTypeCount[3] = 0
  local qualityCountMap = {}
  qualityCountMap[4] = 0
  qualityCountMap[5] = 0
  local groupData = self:GetPlanChips(planId)
  local total = 0
  if groupData then
    for i, v in pairs(groupData) do
      if v then
        local heroType = v:GetHeroType()
        local quality = v:GetQuality()
        if heroTypeCount[heroType] then
          heroTypeCount[heroType] = heroTypeCount[heroType] + 1
        end
        if 4 <= quality then
          qualityCountMap[4] = qualityCountMap[4] + 1
        end
        if 5 <= quality then
          qualityCountMap[5] = qualityCountMap[5] + 1
        end
        total = total + 1
      end
    end
  end
  if 0 < total then
    for heroType, count in ipairs(heroTypeCount) do
      if 0.65 <= count / total then
        name = string.format(PLAN_DEFAULT_NAME, heroType)
        break
      end
    end
  end
  if 4 <= total then
    if 4 <= qualityCountMap[5] then
      color = Color32.New(255, 182, 68, 255)
    elseif 4 <= qualityCountMap[4] then
      color = Color32.New(235, 134, 255, 255)
    end
  end
  return name, color
end

function TacticalChipManager:GetPlanUnlockLevel(planId)
  if not self.planUnlockLevelMap then
    self.planUnlockLevelMap = {}
    local value = LuaEntry.DataConfig:TryGetStr("battlesystem_chip_set_unlock_config", "k1")
    local splitList = string.split(value, "|")
    for i, v in ipairs(splitList) do
      if not string.IsNullOrEmpty(v) then
        self.planUnlockLevelMap[i] = tonumber(v)
      end
    end
  end
  return self.planUnlockLevelMap[planId]
end

function TacticalChipManager:GetLevelTemplate(level)
  local id = level + 10000
  if self.lvTemplateDic[id] == nil then
    local oneTemplate = LocalController:instance():tryGetLine(TableName.LW_DRONE_BATTLESYSTEM_LEVEL, tostring(id))
    if oneTemplate ~= nil then
      local item = LevelTemplate.New()
      item:UpdateData(oneTemplate)
      self.lvTemplateDic[id] = item
    end
  end
  return self.lvTemplateDic[id]
end

function TacticalChipManager:GetTierTemplate(id)
  if self.tierTemplateDic[id] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_DRONE_BATTLESYSTEM_TIER, tostring(id))
    if oneTemplate ~= nil then
      local item = TierTemplate.New()
      item:UpdateData(oneTemplate)
      self.tierTemplateDic[id] = item
    end
  end
  return self.tierTemplateDic[id]
end

function TacticalChipManager:GetTierTemplateSortList()
  if self.tierTemplateList == nil then
    self.tierTemplateList = {}
    LocalController:instance():visitTable(TableName.LW_DRONE_BATTLESYSTEM_TIER, function(id, line)
      if line then
        local item = TierTemplate.New()
        item:UpdateData(line)
        self.tierTemplateDic[id] = item
        table.insert(self.tierTemplateList, item)
      end
    end)
    table.sort(self.tierTemplateList, function(a, b)
      return a.id < b.id
    end)
  end
  return self.tierTemplateList
end

function TacticalChipManager:GetTierEffectValueList()
  local templateList = self:GetTierTemplateSortList()
  if templateList == nil then
    Logger.LogError("templateList is nil")
    return
  end
  local valueList = {}
  for i, v in ipairs(templateList) do
    if v and v.chip_breakthrough_show == 1 then
      table.insert(valueList, v.effectValue)
    end
  end
  local curServerEffectValue = self:GetSystemTierEffectValue()
  if curServerEffectValue > valueList[#valueList] then
    repeat
      local newValue = valueList[#valueList] + 1
      table.insert(valueList, newValue)
    until curServerEffectValue == valueList[#valueList]
  end
  return valueList
end

function TacticalChipManager:GetChipPosIcon(chipType)
  if chipType == nil or chipType <= 0 then
    Logger.LogError("chip data error \239\188\129")
    chipType = TacticalChipType.Opening
  end
  return string.format(CHIP_POS_ICON_PATH, chipType)
end

function TacticalChipManager:GetPreOpenDataList()
  local function parseStrToDataList(str)
    local dataList = {}
    
    local dataListStr = string.split(str, "|")
    for i, v in ipairs(dataListStr) do
      if not string.IsNullOrEmpty(v) then
        local dataStr = string.split(v, ";")
        local data = {}
        data.icon = dataStr[1]
        data.title = dataStr[2]
        data.desc = dataStr[3]
        table.insert(dataList, data)
      end
    end
    return dataList
  end
  
  local needItemId = LuaEntry.DataConfig:TryGetNum(BATTLE_SYSTEM_PREVIEWING_DISPLAY_CONFIG, "k3")
  local itemInfo = DataCenter.ItemData:GetItemById(needItemId)
  local dataStr
  if itemInfo and itemInfo.count > 0 then
    dataStr = LuaEntry.DataConfig:TryGetStr(BATTLE_SYSTEM_PREVIEWING_DISPLAY_CONFIG, "k2")
  else
    dataStr = LuaEntry.DataConfig:TryGetStr(BATTLE_SYSTEM_PREVIEWING_DISPLAY_CONFIG, "k1")
  end
  return parseStrToDataList(dataStr)
end

function TacticalChipManager:NotRecommendedFeed(chipUuid)
  local tipsKey = "battlesystem_consume_chips_confirm2"
  local chipInfo = self:GetChipInfo(chipUuid)
  if chipInfo == nil then
    Logger.LogError("\233\128\137\230\139\169\228\186\134\228\184\141\229\173\152\229\156\168\231\154\132\232\138\175\231\137\135???  chipUuid:" .. tostring(chipUuid))
    return true, tipsKey
  end
  if chipInfo:GetStar() > 0 then
    return true, "battlesystem_consume_chips_confirm4"
  end
  local isMax = DataCenter.TWSkillChipManager:IsMaxQualityInSeries(chipInfo:GetChipSeries(), chipInfo:GetQuality())
  local isEquipSame = self:IsEquipChipBySameConfigId(chipInfo)
  if isEquipSame then
    tipsKey = "battlesystem_consume_chips_confirm3"
  end
  local notMinQuality = chipInfo:GetQuality() > 3
  return (isMax or isEquipSame) and notMinQuality, tipsKey
end

function TacticalChipManager:GetLevel()
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo == nil then
    return 1
  end
  return weaponInfo.chipLv
end

function TacticalChipManager:GetSystemTierEffectValue()
  return math.floor(LuaEntry.Effect:GetGameEffect(50231) + 0.5) or 0
end

function TacticalChipManager:IsEquipChipBySameConfigId(chipInfo)
  if chipInfo == nil then
    return false
  end
  local isEquip = false
  local cfgId = chipInfo:GetId()
  local allMap = DataCenter.TWSkillChipManager:GetEquipChipInfoMap()
  for k, v in pairs(allMap) do
    if v and v:GetId() == cfgId then
      isEquip = true
      break
    end
  end
  return isEquip
end

local TIER_DISPLAY_TIEM_TITLE_PATH = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixinpian_jieji_xiangqingbiaotou0%s.png"

function TacticalChipManager:GetTierDisplayTitleBgPath(tier)
  if tier and 0 < tier then
    return string.format(TIER_DISPLAY_TIEM_TITLE_PATH, tier)
  end
end

local TIER_DISPLAY_TIEM_DESC_PATH = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixinpian_jieji_xiangqing0%s.png"

function TacticalChipManager:GetTierDisplayDescBgPath(tier)
  if tier and 0 < tier then
    return string.format(TIER_DISPLAY_TIEM_DESC_PATH, tier)
  end
end

function TacticalChipManager:GetChipFeedInfo(uuid, data, type, count, addExp)
  local t = {}
  t.uuid = uuid
  t.data = data
  t.type = type
  t.useCount = tonumber(count)
  t.maxCount = tonumber(count)
  t.addExp = tonumber(addExp)
  return t
end

function TacticalChipManager:RecycleChipFeedInfo(t)
  if t == nil then
    return
  end
  t.uuid = 0
  t.data = nil
  t.type = 0
  t.useCount = 0
  t.maxCount = 0
  t.addExp = 0
  if not self.chipFeedInfoPool then
    self.chipFeedInfoPool = {}
  end
  table.insert(self.chipFeedInfoPool, t)
end

function TacticalChipManager.UITextClickTips(eventData, txtCpt)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = txtCpt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = UIUtil.GetString("", linkId)
  param.screenPos = clickPos
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function TacticalChipManager.GetUpgradeStarNeedNumFormat(chipData)
  if not chipData then
    return
  end
  local isMaxStar = chipData:IsMaxStar()
  if isMaxStar == false then
    local haveCount = TacticalWeaponUtils.GetChipUseableCount(chipData)
    if chipData:IsFree() and chipData:GetStar() == 0 then
      haveCount = haveCount - 1
    end
    local commonFragId, fragId, costNum = chipData:GetStarUpCost()
    if costNum and haveCount then
      local haveCountFormat
      if haveCount >= costNum then
        haveCountFormat = string.format("<color=#099b4a>%s</color>", haveCount)
      else
        haveCountFormat = string.format("<color=#f53c3d>%s</color>", haveCount)
      end
      return true, haveCountFormat, costNum
    end
  end
  return false
end

function TacticalChipManager:GetChipFreeCount(chipId)
  local count = 0
  local allChips = DataCenter.TWSkillChipManager:GetAllChips()
  for i, v in pairs(allChips) do
    if v and v:IsFree() and v:GetId() == chipId and v:GetStar() == 0 then
      count = v:GetNum()
      break
    end
  end
  return count
end

return TacticalChipManager
