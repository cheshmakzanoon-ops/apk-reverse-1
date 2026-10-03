local HeroDataManager = BaseClass("HeroDataManager", CEventable)
local Localization = CS.GameEntry.Localization

local function IsRedPointDiffer(self, onOff, flag)
  if onOff then
    if self.remindList[flag] == nil then
      return true
    end
  elseif self.remindList[flag] ~= nil then
    return true
  end
  return false
end

local function RefreshRedPoint(self)
  self:RebuildRemindList()
end

local function RebuildSingleHeroRemind(self, uuid)
  if uuid == nil then
    return nil
  end
  local heroData = self:GetHeroByUuid(uuid)
  if heroData then
    local needRefreshMainUIRedPoint = false
    local needShowRedpoint, list = heroData:NeedShowRedPoint()
    if needShowRedpoint then
      local result
      local upgradeFlag = uuid .. self.RemindFlag.CanUpgrade
      if list[self.RemindFlag.CanUpgrade] ~= nil then
        self.remindList[upgradeFlag] = true
      else
        self.remindList[upgradeFlag] = nil
      end
      local skillUpgradeFlag = uuid .. self.RemindFlag.CanSkillUpgrade
      if list[self.RemindFlag.CanSkillUpgrade] ~= nil then
        self.remindList[skillUpgradeFlag] = true
      else
        self.remindList[skillUpgradeFlag] = nil
      end
      local replaceEquipFlag = uuid .. self.RemindFlag.CanReplaceEquip
      if list[self.RemindFlag.CanReplaceEquip] ~= nil then
        self.remindList[replaceEquipFlag] = true
      else
        self.remindList[replaceEquipFlag] = nil
      end
      local upgradeRankFlag = uuid .. self.RemindFlag.CanUpgradeRank
      if list[self.RemindFlag.CanUpgradeRank] ~= nil then
        self.remindList[upgradeRankFlag] = true
      else
        self.remindList[upgradeRankFlag] = nil
      end
      local value = uuid .. self.RemindFlag.ShowRedPoint
      if self.remindList[value] == nil then
        needRefreshMainUIRedPoint = true
      end
      self.remindList[value] = true
    else
      local upgradeFlag = uuid .. self.RemindFlag.CanUpgrade
      self.remindList[upgradeFlag] = nil
      local skillUpgradeFlag = uuid .. self.RemindFlag.CanSkillUpgrade
      self.remindList[skillUpgradeFlag] = nil
      local replaceEquipFlag = uuid .. self.RemindFlag.CanReplaceEquip
      self.remindList[replaceEquipFlag] = nil
      local upgradeRankFlag = uuid .. self.RemindFlag.CanUpgradeRank
      self.remindList[upgradeRankFlag] = nil
      local value = uuid .. self.RemindFlag.ShowRedPoint
      if self.remindList[value] ~= nil then
        needRefreshMainUIRedPoint = true
      end
      self.remindList[value] = nil
    end
    if needRefreshMainUIRedPoint then
      self.showMainUIRedPoint = true
      EventManager:GetInstance():Broadcast(EventId.RefreshHeroRedPoint)
    end
  end
end

local function OnBuildingUpdate(self)
  self:refreshRedPoint()
end

local function OnHeroSkillMessage(self, message)
  if message == nil then
    return
  end
  local uuid = message.hero.uuid
  RebuildSingleHeroRemind(self, uuid)
end

local function AddListener(self)
  self:RegisterEvent(EventId.HeroSkillUnlockBack, self.OnHeroSkillMessage)
  self:RegisterEvent(EventId.SkillUpgradeEnd, self.OnHeroSkillMessage)
end

local function __init(self)
  self.inited = false
  self.allHero = {}
  self.typeHeroes = {}
  self.typeHeroesDirty = true
  self.heroesHistory = {}
  self.newHeroTags = {}
  self.masterQuality = {}
  self.remindList = {}
  self.remindMarked = false
  self.maxLevel = -1
  self.heroPromoteMap = {}
  self.weaponFreeResetLastTime = 0
  self.showMainUIRedPoint = true
  AddListener(self)
end

local function __delete(self)
  self.inited = nil
  self.allHero = nil
  self.heroesHistory = nil
  self.newHeroTags = nil
  self.masterQuality = nil
  self.maxLevel = nil
  self.weaponFreeResetLastTime = nil
  self.showMainUIRedPoint = true
  self.heroPromoteMap = nil
  self.heroTemplatesCache = nil
end

local function InitData(self, message)
  self.inited = false
  self.heroesHistory = message.digHeroesHistory
  if message.userHero ~= nil then
    self.allHero = {}
    self.masterQuality = {}
    self:UpdateHeroes(message.userHero)
  else
  end
  self:InitHeroPormoteMap()
  self.inited = true
end

local function InitGlobalData(self, message)
  if message.heroMgr == nil then
    return
  end
  if message.heroMgr.weaponTalentFreeResetLastTime ~= nil then
    self.weaponFreeResetLastTime = message.heroMgr.weaponTalentFreeResetLastTime
  end
end

local function UpdateGlobalData(self, message)
  if message == nil then
    return
  end
  if message.weaponTalentFreeResetLastTime ~= nil then
    self.weaponFreeResetLastTime = message.weaponTalentFreeResetLastTime
  end
end

local function GetWeaponFreeResetLastTime(self)
  return self.weaponFreeResetLastTime
end

local function UpdateHeroes(self, array)
  if array ~= nil then
    for k, v in pairs(array) do
      self:UpdateOneHero(v)
    end
  end
end

local function UpdateOneHero(self, message)
  if message == nil then
    return
  end
  local uuid = message.uuid or message.heroUuid
  if uuid == nil then
    return false
  end
  local one = self:GetHeroByUuid(uuid)
  if one ~= nil then
    one:UpdateInfo(message)
  else
    one = HeroInfo.New()
    one:UpdateInfo(message)
    self.allHero[uuid] = one
    if self.inited and not table.hasvalue(self.heroesHistory, tonumber(one.heroId)) then
      table.insert(self.heroesHistory, tonumber(one.heroId))
      self:AddNewHeroTag(uuid)
      if self.inited then
        self.remindMarked = false
      end
      EventManager:GetInstance():Broadcast(EventId.GF_get_new_hero, one)
    end
  end
  self.maxLevel = math.max(self.maxLevel, one.level)
  self.typeHeroesDirty = true
end

local function RemoveOneHeroByUuid(self, uuid)
  if self.allHero[uuid] ~= nil then
    self.allHero[uuid] = nil
  end
  self.typeHeroesDirty = true
end

local function RemoveHeroes(self, heroUuids)
  for _, uuid in pairs(heroUuids) do
    self:RemoveOneHeroByUuid(uuid)
  end
  self.typeHeroesDirty = true
end

local function GetHeroByUuid(self, uuid)
  if uuid == nil then
    return nil
  end
  return self.allHero[uuid]
end

local function RebuildTypeHeroes(self)
  self.typeHeroesDirty = {}
  self.typeHeroes = {}
  for _, v in pairs(self.allHero) do
    if self.typeHeroes[v.heroId] == nil then
      self.typeHeroes[v.heroId] = {v}
    else
      table.insert(self.typeHeroes[v.heroId], v)
    end
  end
  for k, list in pairs(self.typeHeroes) do
    table.sort(list, function(heroA, heroB)
      if heroA.quality ~= heroB.quality then
        return heroA.quality > heroB.quality
      end
      return heroA.level > heroB.level
    end)
  end
  self.typeHeroesDirty = false
end

local function IsTheOptimalHeroInSameId(self, heroData)
  if heroData.isMaster then
    return true, heroData.uuid
  end
  local optimal
  for _, v in pairs(self.allHero) do
    if v.heroId == heroData.heroId and v.isMaster then
      optimal = v.uuid
      break
    end
  end
  return false, optimal
end

local function GetHeroByHeroId(self, heroId)
  local uuid = self:GetHeroUuidByHeroId(heroId)
  return self:GetHeroByUuid(uuid)
end

local function GetHeroUuidByHeroId(self, heroId)
  heroId = tonumber(heroId)
  for _, v in pairs(self.allHero) do
    if heroId == v.heroId then
      return v.uuid
    end
  end
  return ""
end

local function GetAllHeroList(self)
  return self.allHero
end

local function GetHeroSortList(self)
  local heroList = {}
  table.walksort(self.allHero, function(leftKey, rightKey)
    local heroA = self.allHero[leftKey]
    local heroB = self.allHero[rightKey]
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end, function(k, v)
    if not v.isMaster then
    else
      heroList[#heroList + 1] = v
    end
  end)
  return heroList
end

local function GetAllHeroBySort(self)
  local heroList = {}
  table.walksort(self.allHero, function(leftKey, rightKey)
    local heroA = self.allHero[leftKey]
    local heroB = self.allHero[rightKey]
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end, function(k, v)
    if heroList[v.heroId] == nil then
      heroList[v.heroId] = v
    end
  end)
  return heroList
end

local function GetHeroListForCollect(self)
  local collectHeroList = {}
  local lowQualityHeroList = {}
  table.walksort(self.allHero, function(leftKey, rightKey)
    local heroA = self.allHero[leftKey]
    local heroB = self.allHero[rightKey]
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end, function(k, v)
    if not v.isMaster then
    else
      local id = v.heroId
      local tags = HeroUtils.GetTagsByHeroId(id)
      local isCollectHero = false
      for a, b in pairs(tags) do
        if b == 13 then
          isCollectHero = true
        end
      end
      if isCollectHero then
        if collectHeroList[v.heroId] == nil then
          collectHeroList[v.heroId] = v
        end
      elseif v.rarity >= 3 and lowQualityHeroList[v.heroId] == nil then
        lowQualityHeroList[v.heroId] = v
      end
    end
  end)
  return collectHeroList, lowQualityHeroList
end

local function GetHeroIdListInMarch(self)
  local heroIdList = {}
  table.walk(self.allHero, function(k, v)
    if v.state == ArmyFormationState.March then
      heroIdList[v.heroId] = 1
    end
  end)
  return heroIdList
end

local function GetAllHeroIdList(self, excludeList)
  local heroIdList = {}
  local i = 1
  table.walk(self.allHero, function(k, v)
    local exclude = false
    if excludeList and table.indexof(excludeList, v.uuid) then
      exclude = true
    end
    if not exclude then
      heroIdList[i] = v.heroId
      i = i + 1
    end
  end)
  return heroIdList
end

local function IsInHistory(self, heroId)
  heroId = tonumber(heroId)
  if self.heroesHistory == nil then
    return false
  end
  return table.hasvalue(self.heroesHistory, heroId)
end

local function AddNewHeroTag(self, newHeroUuid)
  if not table.hasvalue(self.newHeroTags, newHeroUuid) then
    table.insert(self.newHeroTags, newHeroUuid)
    local hero_info = self:GetHeroByUuid(newHeroUuid)
    DataCenter.BuildHeroManager:AddNewHero(hero_info.heroId)
  end
  self:RebuildRemindList()
end

local function RemoveNewHeroTag(self, newHeroUuid)
  local refreshFlag = false
  if self:IsNewHero(newHeroUuid) then
    refreshFlag = true
  end
  table.removebyvalue(self.newHeroTags, newHeroUuid)
  if refreshFlag then
    EventManager:GetInstance():Broadcast(EventId.OnRemoveNewHeroFlag)
  end
end

local function ClearNewHeroTags(self)
  self.newHeroTags = {}
end

local function IsNewHero(self, heroUuid)
  return table.hasvalue(self.newHeroTags, heroUuid)
end

local function GetHeroRedNum(self)
  local needRemind = table.count(self.remindList) > 0 and not self.remindMarked
  return needRemind and 1 or 0
end

local function MarkHeroRedPoint(self)
  self.remindMarked = true
end

local function GetAllTypeHeroes(self)
  if self.typeHeroesDirty then
    self:RebuildTypeHeroes()
  end
  return self.typeHeroes
end

HeroDataManager.RemindFlag = {
  NewHero = 1,
  CanUpgrade = 2,
  CanSkillUpgrade = 3,
  CanReplaceEquip = 4,
  CanUpgradeRank = 5,
  ShowRedPoint = 7
}

local function RebuildRemindList(self)
  local list = {}
  for _, uuid in pairs(self.newHeroTags) do
    local value = uuid .. self.RemindFlag.NewHero
    list[value] = true
    if self.remindMarked and not table.hasvalue(self.remindList, value) then
      self.remindMarked = false
    end
  end
  local flag = false
  local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
  local needRefreshMainUIRedPoint = false
  for uuid, heroData in pairs(self.allHero) do
    local needShowRedpoint, redPointList = heroData:NeedShowRedPoint(expCount)
    if needShowRedpoint then
      local upgradeFlag = uuid .. self.RemindFlag.CanUpgrade
      if redPointList[self.RemindFlag.CanUpgrade] ~= nil then
        list[upgradeFlag] = true
      end
      local skillUpgradeFlag = uuid .. self.RemindFlag.CanSkillUpgrade
      if redPointList[self.RemindFlag.CanSkillUpgrade] ~= nil then
        list[skillUpgradeFlag] = true
      end
      local replaceEquipFlag = uuid .. self.RemindFlag.CanReplaceEquip
      if redPointList[self.RemindFlag.CanReplaceEquip] ~= nil then
        list[replaceEquipFlag] = true
      end
      local upgradeRankFlag = uuid .. self.RemindFlag.CanUpgradeRank
      if redPointList[self.RemindFlag.CanUpgradeRank] ~= nil then
        list[upgradeRankFlag] = true
      end
      local value = uuid .. self.RemindFlag.ShowRedPoint
      list[value] = true
      flag = true
      if self.remindList[value] == nil then
        needRefreshMainUIRedPoint = true
      end
    else
      local value = uuid .. self.RemindFlag.ShowRedPoint
      if self.remindList[value] ~= nil then
        needRefreshMainUIRedPoint = true
      end
    end
  end
  if flag then
    self.remindMarked = false
  end
  self.remindList = list
  if needRefreshMainUIRedPoint then
    self.showMainUIRedPoint = true
    EventManager:GetInstance():Broadcast(EventId.RefreshHeroRedPoint)
  end
end

local function GetFreeAddTimeHero(self, type)
  return false
end

local function BeyondHero(self, heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local maxLevel = HeroUtils.GetMaxLevelByQuality(heroData.heroId, heroData.quality)
  if maxLevel <= heroData.level then
    local name = Localization:GetString(heroData.config.name)
    local quality = HeroUtils.GetNextMaxLevelByQuality(heroData.heroId, heroData.quality, heroData.level)
    local star = HeroUtils.GetHeroStarAndProgress(quality)
    if star <= 0 then
      return
    end
    local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(heroData.rarity), name)
    UIUtil.ShowMessage(Localization:GetString("129232", heroName, tostring(star)), 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceSuccess, heroUuid)
    end)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBeyond, {
    anim = true,
    hideTop = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, heroUuid)
end

local function GetHighestHeroLevel(self)
  local result = 0
  table.walk(self.allHero, function(_, v)
    if v.level > result then
      result = v.level
    end
  end)
  return result
end

local function HasBeyondHero(self)
  local result = false
  for _, v in pairs(self.allHero) do
    if v ~= nil and v:NeedBeyond() then
      result = true
      break
    end
  end
  return result
end

local function GetMasterQuality(self, heroId)
  if self.masterQuality == nil then
    self.masterQuality = {}
  end
  if self.masterQuality[heroId] ~= nil then
    return self.masterQuality[heroId]
  end
  for _, v in pairs(self.allHero) do
    if v ~= nil and v.isMaster and v.heroId == heroId then
      self.masterQuality[heroId] = v.quality
      break
    end
  end
  if self.masterQuality[heroId] ~= nil then
    return self.masterQuality[heroId]
  end
  return 1
end

local function SetMasterQuality(self, heroId, quality)
  if self.masterQuality == nil then
    self.masterQuality = {}
  end
  self.masterQuality[heroId] = quality
end

local function NeedShowNewHeroWindow(self, heroUuid)
  local showFlag = false
  if DataCenter.GuideManager:InGuide() then
    showFlag = true
  else
    local data = self:GetHeroByUuid(heroUuid)
    if data ~= nil and (data.quality == HeroQualityType.Legendary or data.quality == HeroQualityType.Genius) then
      showFlag = true
    end
  end
  return showFlag
end

local function hasStarUpHero(self)
  for _, v in pairs(self.allHero) do
    if v.quality > 1 then
      return true
    end
  end
  return false
end

local function hasCanStarUpHero(self)
  for _, v in pairs(self.allHero) do
    if v:CanUpgradeStar() then
      return true
    end
  end
  return false
end

local function GetLowQualityHeroCount(self)
  local count = 0
  for _, v in pairs(self.allHero) do
    if v.quality <= 4 then
      count = count + 1
    end
  end
  return count
end

local function IsHeroNeedRedPoint(self, uuid)
  local redPointFlag = uuid .. self.RemindFlag.ShowRedPoint
  return self.remindList[redPointFlag] ~= nil
end

local function IsHeroShowTypeRedPoint(self, uuid)
  local redPointFlag = uuid .. self.RemindFlag.ShowRedPoint
  return self.remindList[redPointFlag] ~= nil
end

local function StopMainUIRedPoint(self)
  if self.showMainUIRedPoint == false then
    return
  end
  self.showMainUIRedPoint = false
  EventManager:GetInstance():Broadcast(EventId.RefreshHeroRedPoint)
end

local function CanShowMainUIRedPoint(self)
  return self.showMainUIRedPoint
end

local function GetHeroCanUpgradeInfos(self, heroData)
  local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  local heroFinalLevel = HeroUtils.GetMaxLevelWithScienceLimit()
  local heroLevel = heroData.level
  local overFinalLevel = heroFinalLevel <= heroLevel
  local reachLevelLimit = heroLevelLimit <= heroLevel
  local canUpgrade = not overFinalLevel and not reachLevelLimit
  local canUpgradeWithoutExpItems = false
  if not reachLevelLimit then
    local costResources = HeroUtils.GetLevelUpCostResources(heroLevel)
    for resourceId, cost in pairs(costResources) do
      local have = LuaEntry.Resource:GetCntByResType(resourceId)
      canUpgrade = canUpgrade and (cost <= 0 or cost <= have)
    end
    canUpgradeWithoutExpItems = canUpgrade
  end
  if not overFinalLevel then
    local costExpCount = HeroUtils.GetLevelUpNeedExp(heroData.level)
    if 0 < costExpCount then
      local hasExpCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
      if costExpCount > hasExpCount then
        canUpgrade = false
      end
    end
  end
  return canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit
end

local function GetBestHeroByPower(self)
  local best
  for _, v in pairs(self.allHero) do
    if best == nil or best.power < v.power then
      best = v
    end
  end
  return best
end

local function GetHeroesByType(self, heroType)
  local allHeroes = self:GetAllHeroList()
  local heroes = {}
  if table.IsNullOrEmpty(allHeroes) then
    return heroes
  end
  for _, v in pairs(allHeroes) do
    if not heroType or v.heroType == heroType then
      table.insert(heroes, v)
    end
  end
  return heroes
end

local function SortByPower(a, b)
  return a.power > b.power
end

function HeroDataManager:AutoFillArmyFormation(squadData, saveType)
  if squadData == nil then
    return 0
  end
  squadData:ClearLocalHeroes()
  local emptySlot = squadData:GetEmptySlotIndex()
  if emptySlot ~= nil then
    local heroCount = 0
    local heroUuid
    local used = {}
    local mgr = DataCenter.ArmyFormationDataManager
    local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
    local freeHeroList = {}
    for uuid, heroData in pairs(heroDataList) do
      if mgr:GetHeroSquadIndex(uuid) == nil then
        table.insert(freeHeroList, heroData)
      end
    end
    table.sort(freeHeroList, function(a, b)
      if a.quality > b.quality then
        return true
      elseif a.quality < b.quality then
        return false
      else
        local rankA = a:GetMaxAvailableRankByFrag()
        local rankB = b:GetMaxAvailableRankByFrag()
        if rankA > rankB then
          return true
        elseif rankA < rankB then
          return false
        elseif a.level > b.level then
          return true
        elseif a.level < b.level then
          return false
        else
          return false
        end
      end
      return false
    end)
    local topFive = {}
    table.move(freeHeroList, 1, math.min(5, #freeHeroList), 1, topFive)
    local tanks = {}
    local others = {}
    for slotIndex = 1, 5 do
      local localHeroUuid = squadData:GetLocalHeroAtSlotIndex(slotIndex)
      heroUuid = nil
      if slotIndex == 1 or slotIndex == 2 then
        for _, heroData in ipairs(topFive) do
          if heroData and used[heroData.uuid] == nil and heroData.heroJob == HeroJob.Defense then
            used[heroData.uuid] = 1
            heroUuid = heroData.uuid
            tanks[slotIndex] = heroData.uuid
            if heroData.uuid ~= localHeroUuid then
              heroCount = heroCount + 1
            end
            break
          end
        end
      end
      if heroUuid == nil then
        for _, heroData in ipairs(topFive) do
          if heroData and used[heroData.uuid] == nil then
            used[heroData.uuid] = 1
            heroUuid = heroData.uuid
            others[slotIndex] = heroData.uuid
            if heroData.uuid ~= localHeroUuid then
              heroCount = heroCount + 1
            end
            break
          end
        end
      end
    end
    if heroCount == 0 then
      return heroCount
    end
    for slotIndex = 1, 5 do
      squadData:SetLocalHero(slotIndex, tanks[slotIndex] and tanks[slotIndex] or others[slotIndex])
    end
    if 0 < heroCount then
      local curHeroes = squadData:GetLocalAllHeroes()
      SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, squadData.uuid, curHeroes, saveType)
    end
    return heroCount
  end
  return 0
end

local function InitHeroPormoteMap(self)
  self.heroPromoteMap = {}
  local k2 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k2") or ""
  local k3 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k3") or ""
  if not string.IsNullOrEmpty(k2) and not string.IsNullOrEmpty(k3) then
    local oldIds = string.split(k2, "|")
    local newIds = string.split(k3, "|")
    if #oldIds == #newIds then
      for index, value in ipairs(oldIds) do
        self.heroPromoteMap[oldIds[index]] = newIds[index]
      end
    end
  end
end

local function GetHeroPromoteId(self, oldId)
  if self.heroPromoteMap[oldId] then
    return self.heroPromoteMap[oldId]
  end
  return nil
end

local function GetHeroTemplateReadOnly(self, id, level, rankLv, skillLevels, uniqueWeaponLv, skillInfos, weaponUnitLvs, awakenLv, skinId)
  if id == nil then
    return nil
  end
  if self.heroTemplatesCache == nil then
    self.heroTemplatesCache = {}
  end
  local heroId = id
  local heroLevel = level
  local heroRank = rankLv
  local skillLevels = skillLevels or {}
  local uniqueWeaponLv = uniqueWeaponLv or 0
  local weaponUnitLvs = weaponUnitLvs or {}
  local str_tmp = {}
  local temp = {}
  for _, v in pairs(weaponUnitLvs) do
    temp[v.slot] = v.lv
  end
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    table.insert(str_tmp, tostring(temp[i] or 0))
  end
  local weaponUnitLvs_str = table.concat(str_tmp, "_")
  str_tmp = {}
  table.insert(str_tmp, tostring(heroId))
  table.insert(str_tmp, "_")
  table.insert(str_tmp, tostring(heroRank))
  table.insert(str_tmp, "_")
  table.insert(str_tmp, tostring(heroLevel))
  table.insert(str_tmp, "_")
  table.insert(str_tmp, tostring(uniqueWeaponLv))
  table.insert(str_tmp, "_")
  table.insert(str_tmp, weaponUnitLvs_str)
  table.insert(str_tmp, "_")
  table.insert(str_tmp, tostring(awakenLv))
  table.insert(str_tmp, "_")
  table.insert(str_tmp, tostring(skinId))
  local key = table.concat(str_tmp, "")
  local result
  if self.heroTemplatesCache[key] == nil then
    local heroInfo = HeroInfo.New()
    heroInfo:UpdateFromTemplate(heroId, heroLevel, heroRank, skillLevels, uniqueWeaponLv, skillInfos, awakenLv, skinId)
    self.heroTemplatesCache[key] = {}
    local list = self.heroTemplatesCache[key]
    list[#list + 1] = heroInfo
    result = heroInfo
  else
    local list = self.heroTemplatesCache[key]
    for i = 1, #list do
      local heroInfo = list[i]
      local skillList = heroInfo:GetAllSkillsReadOnly()
      if type(skillLevels) == "table" then
        for _, skill in pairs(skillList) do
          local skillId = skill.skillId
          if not skillLevels[skillId] or skillLevels[skillId] ~= skill.level then
            goto lbl_212
          end
        end
      elseif type(skillLevels) == "number" then
        for _, skill in pairs(skillList) do
          if skillLevels ~= skill.level then
            goto lbl_212
          end
        end
      end
      result = heroInfo
      do break end
      ::lbl_212::
    end
    if not result then
      local heroInfo = HeroInfo.New()
      heroInfo:UpdateFromTemplate(heroId, heroLevel, heroRank, skillLevels, uniqueWeaponLv, skillInfos, awakenLv, skinId)
      self.heroTemplatesCache[key] = {}
      local list = self.heroTemplatesCache[key]
      list[#list + 1] = heroInfo
      result = heroInfo
    end
  end
  return result or {}
end

local function SetShowHeroUuidCache(self, uuid)
  if self.curShowHeroUuid == nil or self.curShowHeroUuid ~= uuid then
    EventManager:GetInstance():Broadcast(EventId.EffectOverviewShowHeroChange)
  end
  self.curShowHeroUuid = uuid
end

local function GetShowHeroUuidCache(self)
  return self.curShowHeroUuid
end

function HeroDataManager:UnlockHeroUWEnhance(heroUuid)
  local heroData = self:GetHeroByUuid(heroUuid)
  if heroData then
    heroData:UnlockEnhanceUW()
  else
    Logger.LogError("HeroDataManager:UnlockHeroUWEnhance failed, heroUuid: " .. heroUuid)
  end
end

function HeroDataManager:GetHeroCountByLevel(level)
  local count = 0
  for _, v in pairs(self.allHero) do
    if level <= v.level then
      count = count + 1
    end
  end
  return count
end

function HeroDataManager:GetHeroCountByStar(star)
  local count = 0
  for _, v in pairs(self.allHero) do
    if v.rank and 0 < v.rank and star <= (v.rank - 1) / 5 then
      count = count + 1
    end
  end
  return count
end

HeroDataManager.__init = __init
HeroDataManager.__delete = __delete
HeroDataManager.InitData = InitData
HeroDataManager.UpdateOneHero = UpdateOneHero
HeroDataManager.GetHeroByUuid = GetHeroByUuid
HeroDataManager.UpdateHeroes = UpdateHeroes
HeroDataManager.RemoveOneHeroByUuid = RemoveOneHeroByUuid
HeroDataManager.RemoveHeroes = RemoveHeroes
HeroDataManager.GetHeroIdListInMarch = GetHeroIdListInMarch
HeroDataManager.GetAllHeroList = GetAllHeroList
HeroDataManager.IsTheOptimalHeroInSameId = IsTheOptimalHeroInSameId
HeroDataManager.IsInHistory = IsInHistory
HeroDataManager.GetHeroUuidByHeroId = GetHeroUuidByHeroId
HeroDataManager.GetHeroByHeroId = GetHeroByHeroId
HeroDataManager.GetAllHeroBySort = GetAllHeroBySort
HeroDataManager.GetHeroSortList = GetHeroSortList
HeroDataManager.hasCanStarUpHero = hasCanStarUpHero
HeroDataManager.AddNewHeroTag = AddNewHeroTag
HeroDataManager.RemoveNewHeroTag = RemoveNewHeroTag
HeroDataManager.ClearNewHeroTags = ClearNewHeroTags
HeroDataManager.IsNewHero = IsNewHero
HeroDataManager.MarkHeroRedPoint = MarkHeroRedPoint
HeroDataManager.RebuildTypeHeroes = RebuildTypeHeroes
HeroDataManager.GetAllTypeHeroes = GetAllTypeHeroes
HeroDataManager.RebuildRemindList = RebuildRemindList
HeroDataManager.GetHeroRedNum = GetHeroRedNum
HeroDataManager.GetFreeAddTimeHero = GetFreeAddTimeHero
HeroDataManager.BeyondHero = BeyondHero
HeroDataManager.GetHighestHeroLevel = GetHighestHeroLevel
HeroDataManager.HasBeyondHero = HasBeyondHero
HeroDataManager.GetMasterQuality = GetMasterQuality
HeroDataManager.SetMasterQuality = SetMasterQuality
HeroDataManager.GetHeroListForCollect = GetHeroListForCollect
HeroDataManager.NeedShowNewHeroWindow = NeedShowNewHeroWindow
HeroDataManager.hasStarUpHero = hasStarUpHero
HeroDataManager.GetLowQualityHeroCount = GetLowQualityHeroCount
HeroDataManager.InitGlobalData = InitGlobalData
HeroDataManager.UpdateGlobalData = UpdateGlobalData
HeroDataManager.GetWeaponFreeResetLastTime = GetWeaponFreeResetLastTime
HeroDataManager.IsHeroNeedRedPoint = IsHeroNeedRedPoint
HeroDataManager.IsHeroShowTypeRedPoint = IsHeroShowTypeRedPoint
HeroDataManager.StopMainUIRedPoint = StopMainUIRedPoint
HeroDataManager.CanShowMainUIRedPoint = CanShowMainUIRedPoint
HeroDataManager.GetHeroCanUpgradeInfos = GetHeroCanUpgradeInfos
HeroDataManager.GetBestHeroByPower = GetBestHeroByPower
HeroDataManager.GetHeroesByType = GetHeroesByType
HeroDataManager.GetAllHeroIdList = GetAllHeroIdList
HeroDataManager.InitHeroPormoteMap = InitHeroPormoteMap
HeroDataManager.GetHeroPromoteId = GetHeroPromoteId
HeroDataManager.RebuildSingleHeroRemind = RebuildSingleHeroRemind
HeroDataManager.OnHeroSkillMessage = OnHeroSkillMessage
HeroDataManager.RefreshRedPoint = RefreshRedPoint
HeroDataManager.OnBuildingUpdate = OnBuildingUpdate
HeroDataManager.GetHeroTemplateReadOnly = GetHeroTemplateReadOnly
HeroDataManager.SetShowHeroUuidCache = SetShowHeroUuidCache
HeroDataManager.GetShowHeroUuidCache = GetShowHeroUuidCache
return HeroDataManager
