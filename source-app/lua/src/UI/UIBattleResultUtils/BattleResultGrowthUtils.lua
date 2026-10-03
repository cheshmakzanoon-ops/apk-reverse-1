local BattleResultGrowthUtils = {}
local STRONG_SPECIAL_PREFAB_NAME = "CommonResultGetStrongerSpecialList"
local SPECIAL_PREFAB_NAME = "CommonResultGetStrongerList"
local CommonResultGetStrongerListComponent = require("UI.UIBattleResultComponents.CommonResultGetStrongerListComponent")
local CommonResultGetStrongerSpecialListComponent = require("UI.UIBattleResultComponents.CommonResultGetStrongerSpecialListComponent")
local Localization = CS.GameEntry.Localization
local TANK_BUILDING_ID = 10116000
local MAIN_CITY_BUILDING_ID = 10100000
local RECRUIT_BUILDING_ID = 10120000
local needAdjustFormationData
local GrowthWayType = {
  FirstPay = 1,
  ArmedUpgrade = 2,
  HeroLevelUpgrade = 3,
  HeroEquip = 4,
  UpgradeHeroStar = 5,
  AdjustFormation = 6,
  RecruitHero = 7,
  CityUpgrade = 8,
  TankUpgrade = 9,
  RadarDetect = 10,
  DominatorUpgrade = 11,
  WeaponUpgrade = 12,
  DecorationUpgrade = 13,
  HeroSkill = 14
}

local function OnFirstPayBtnGo()
  EventManager:GetInstance():Broadcast(EventId.ShowFirstPayUI)
end

local function OnArmedUpgradeGo()
  DataCenter.LWArmedUpgradeManager:JumpToArmedUpgradeCityModel()
end

local function OnHeroLevelUpgradeGo(heroUuid, heroList)
  local arrowData = {
    arrowType = HeroDetailGuideArrowType.Upgrade,
    heroUid = heroUuid,
    pointLevelBtn = true
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, heroList or HeroUtils.GenerateHeroDataList(0), nil, arrowData)
end

local function OnRecruitHeroGo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true})
end

local function OnHeroSkillUpgradeGo(heroUuid, skillSlot, heroList)
  local arrowData = {
    arrowType = HeroDetailGuideArrowType.Skill,
    heroUid = heroUuid,
    skillSlotIndex = skillSlot
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, heroList or HeroUtils.GenerateHeroDataList(0), nil, arrowData)
end

local function OnMainCityGo()
  GoToUtil.GotoCityByBuildId(MAIN_CITY_BUILDING_ID, WorldTileBtnType.City_Upgrade, nil, true)
end

local function OnTankGo(tankData, HeroType)
  if tankData == nil then
    if not HeroType then
      GoToUtil.GotoCityByBuildId(TANK_BUILDING_ID, WorldTileBtnType.City_Upgrade)
    else
      local buildingId = BattleResultGrowthUtils.GetBuildingIdByHeroType(HeroType)
      GoToUtil.GotoCityByBuildId(buildingId, WorldTileBtnType.City_Upgrade)
    end
  elseif not HeroType then
    GoToUtil.GotoCityByBuildId(TANK_BUILDING_ID, WorldTileBtnType.City_Upgrade, nil, true)
  else
    local buildingId = BattleResultGrowthUtils.GetBuildingIdByHeroType(HeroType)
    GoToUtil.GotoCityByBuildId(buildingId, WorldTileBtnType.City_Upgrade, nil, true)
  end
end

local function OnHeroEquipUpgradeGo(heroUuid, heroList, showQuickEquipGuide)
  local arrowData = {
    arrowType = HeroDetailGuideArrowType.Equip,
    heroUid = heroUuid,
    showQuickEquipBtnGuide = showQuickEquipGuide
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, heroList or HeroUtils.GenerateHeroDataList(0), nil, arrowData)
end

local function OnRadarGo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
end

local function OnDominatorGo(dominatorId)
  if dominatorId then
    DataCenter.DominatorManager:OpenDominatorMain(dominatorId)
  end
end

local function OnWeaponGo()
  local hasWeapon = false
  local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(weapons) then
    for i, v in pairs(weapons) do
      hasWeapon = true
      break
    end
  end
  if not hasWeapon then
    UIUtil.ShowTipsId("develop_guide_tip6")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.Basic)
  end
end

local function OnDecorationGo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBook)
end

local function OnUpgradeHeroStarGo(heroUuid)
  local arrowData = {
    arrowType = HeroDetailGuideArrowType.Rank,
    heroUid = heroUuid
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, HeroUtils.GenerateHeroDataList(0), nil, arrowData)
end

local function OnAdjustFormationGo()
end

local firstPayItemCfg = {
  type = GrowthWayType.FirstPay,
  cmp = CommonResultGetStrongerSpecialListComponent,
  prefabName = STRONG_SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_UR_hero.png",
  name = Localization:GetString("2000328"),
  bgSpec = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_UR.png",
  goAction = OnFirstPayBtnGo
}
firstPayItemCfg.__index = firstPayItemCfg
local armedUpgradeItemCfg = {
  type = GrowthWayType.ArmedUpgrade,
  cmp = CommonResultGetStrongerSpecialListComponent,
  prefabName = STRONG_SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_SSR_hero.png",
  name = Localization:GetString("armed_upgrade_defeat"),
  bgSpec = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_SSR.png",
  goAction = OnArmedUpgradeGo
}
armedUpgradeItemCfg.__index = armedUpgradeItemCfg
local japanArmedUpgradeItemCfg = {
  type = GrowthWayType.ArmedUpgrade,
  cmp = CommonResultGetStrongerSpecialListComponent,
  prefabName = STRONG_SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_SSR_japanhero.png",
  name = Localization:GetString("armed_upgrade_defeat"),
  bgSpec = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_SSR.png",
  goAction = OnArmedUpgradeGo
}
japanArmedUpgradeItemCfg.__index = japanArmedUpgradeItemCfg
local heroLevelUpgradeItemCfg = {
  type = GrowthWayType.HeroLevelUpgrade,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_yingxiong_icon.png",
  name = Localization:GetString("140062"),
  goAction = OnHeroLevelUpgradeGo
}
heroLevelUpgradeItemCfg.__index = heroLevelUpgradeItemCfg
local upgradeHeroStarItemCfg = {
  type = GrowthWayType.UpgradeHeroStar,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_shengxing_icon.png",
  name = Localization:GetString("battle_lose_star_limit"),
  goAction = OnUpgradeHeroStarGo
}
upgradeHeroStarItemCfg.__index = upgradeHeroStarItemCfg
local AdjustFormationItemCfg = {
  type = GrowthWayType.AdjustFormation,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_zhanwei_icon.png",
  name = Localization:GetString("battle_lose_relocate_limit"),
  goAction = OnAdjustFormationGo
}
AdjustFormationItemCfg.__index = AdjustFormationItemCfg
local recruitHeroItemCfg = {
  type = GrowthWayType.RecruitHero,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_zhaomu_icon.png",
  name = Localization:GetString("450005"),
  goAction = OnRecruitHeroGo
}
recruitHeroItemCfg.__index = recruitHeroItemCfg
local heroSkillItemCfg = {
  type = GrowthWayType.HeroSkill,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_shengxing_icon.png",
  name = Localization:GetString("450007"),
  goAction = OnHeroSkillUpgradeGo
}
heroSkillItemCfg.__index = heroSkillItemCfg
local cityUpgradeItemCfg = {
  type = GrowthWayType.CityUpgrade,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_jidi_icon.png",
  name = Localization:GetString("130209", Localization:GetString("135104")),
  goAction = OnMainCityGo
}
cityUpgradeItemCfg.__index = cityUpgradeItemCfg
local tankUpgradeItemCfg = {
  type = GrowthWayType.TankUpgrade,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_tanke_icon.png",
  name = Localization:GetString("battle_lose_building_limit", Localization:GetString("129031")),
  goAction = OnTankGo
}
tankUpgradeItemCfg.__index = tankUpgradeItemCfg
local heroEquipItemCfg = {
  type = GrowthWayType.HeroEquip,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_zhuangbei_icon.png",
  name = Localization:GetString("260000"),
  goAction = OnHeroEquipUpgradeGo
}
heroEquipItemCfg.__index = heroEquipItemCfg
local RadarDetectItemCfg = {
  type = GrowthWayType.RadarDetect,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_bianqiang_leida_icon.png",
  name = Localization:GetString("121289"),
  goAction = OnRadarGo
}
RadarDetectItemCfg.__index = RadarDetectItemCfg
local dominatorUpgradeItemCfg = {
  type = GrowthWayType.DominatorUpgrade,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/UILWBattle/UI_building_10236000.png",
  name = Localization:GetString("dominator_pve_dec_12"),
  goAction = OnDominatorGo
}
dominatorUpgradeItemCfg.__index = dominatorUpgradeItemCfg
local weaponUpgradeItemCfg = {
  type = GrowthWayType.WeaponUpgrade,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/UILWBattle/UI_building_10143000.png",
  name = Localization:GetString("dominator_pve_dec_13"),
  goAction = OnWeaponGo
}
weaponUpgradeItemCfg.__index = weaponUpgradeItemCfg
local decorationUpgradeItemCfg = {
  type = GrowthWayType.DecorationUpgrade,
  cmp = CommonResultGetStrongerListComponent,
  prefabName = SPECIAL_PREFAB_NAME,
  icon = "Assets/Main/Sprites/UI/UILWBattle/UI_building_10219000.png",
  name = Localization:GetString("dominator_pve_dec_14"),
  goAction = OnDecorationGo
}
decorationUpgradeItemCfg.__index = decorationUpgradeItemCfg
local GrowthWayConfigs = {
  [GrowthWayType.FirstPay] = firstPayItemCfg,
  [GrowthWayType.ArmedUpgrade] = armedUpgradeItemCfg,
  [GrowthWayType.HeroLevelUpgrade] = heroLevelUpgradeItemCfg,
  [GrowthWayType.RecruitHero] = recruitHeroItemCfg,
  [GrowthWayType.HeroSkill] = heroSkillItemCfg,
  [GrowthWayType.CityUpgrade] = cityUpgradeItemCfg,
  [GrowthWayType.TankUpgrade] = tankUpgradeItemCfg,
  [GrowthWayType.HeroEquip] = heroEquipItemCfg,
  [GrowthWayType.RadarDetect] = RadarDetectItemCfg,
  [GrowthWayType.DominatorUpgrade] = dominatorUpgradeItemCfg,
  [GrowthWayType.WeaponUpgrade] = weaponUpgradeItemCfg,
  [GrowthWayType.DecorationUpgrade] = decorationUpgradeItemCfg,
  [GrowthWayType.UpgradeHeroStar] = upgradeHeroStarItemCfg,
  [GrowthWayType.AdjustFormation] = AdjustFormationItemCfg
}

function BattleResultGrowthUtils.GetGrowthWayConfigs(growthWays)
  local cfgs = {}
  if growthWays then
    for i, v in ipairs(growthWays) do
      local cfg = {}
      table.insert(cfgs, cfg)
      if GrowthWayConfigs[v] then
        if v == GrowthWayType.ArmedUpgrade and LuaEntry.Player.JPUser then
          setmetatable(cfg, japanArmedUpgradeItemCfg)
        else
          setmetatable(cfg, GrowthWayConfigs[v])
        end
      end
    end
  end
  return cfgs
end

function BattleResultGrowthUtils.CanFirstPay()
  local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
  if isNewFirstPay then
    local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
    isNewFirstPay = firstPayPack ~= nil
  else
    local firstPayState = DataCenter.FirstPayManager:GetState()
    isNewFirstPay = firstPayState >= FirstPayState.Unrepaired and firstPayState < FirstPayState.HasReceivedNormalReward
  end
  return isNewFirstPay
end

function BattleResultGrowthUtils.CanArmedUpgrade()
  local armedUpgradeOpen = DataCenter.LWArmedUpgradeManager:IsArmedUpgradeOpen(true)
  local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
  return armedUpgradeOpen and canLevelUp
end

function BattleResultGrowthUtils.GetTeamGrowthInfo(team)
  local maxQualityUpgradeLevelHeroUuid = 0
  local equipHeroUuid = 0
  local skillUpHeroUuid = 0
  local skillUpHeroSlotIndex = 0
  local levelNeedCityUpgrade = false
  local maxQualityUpgrade = -1
  if team then
    local cityData = DataCenter.BuildManager.buildIdBuilding[MAIN_CITY_BUILDING_ID]
    local hasCity = cityData ~= nil and #cityData == 1
    for i, heroUnit in ipairs(team) do
      local heroData = heroUnit.hero or heroUnit
      local heroUuid = heroData.uuid
      local canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(heroData)
      canUpgrade = not overFinalLevel and not reachLevelLimit
      if canUpgrade and maxQualityUpgrade < heroData.quality then
        maxQualityUpgradeLevelHeroUuid = heroUuid
        maxQualityUpgrade = heroData.quality
      end
      if hasCity and (heroData.finalLevel == nil and heroData.level < 100 or heroData.finalLevel ~= nil and heroData.level < heroData.finalLevel) then
        levelNeedCityUpgrade = true
      end
      local equip = DataCenter.EquipDataManager:GetHeroBetterEquip(heroData)
      if equip then
        equipHeroUuid = heroUuid
      end
      local skill = heroData:GetCanUpgradeSkill()
      if skill then
        skillUpHeroUuid = heroUuid
        skillUpHeroSlotIndex = skill.slotIndex
      end
    end
  end
  return maxQualityUpgradeLevelHeroUuid, levelNeedCityUpgrade, equipHeroUuid, skillUpHeroUuid, skillUpHeroSlotIndex
end

function BattleResultGrowthUtils:GetTeamGrowthInfoDefault(team)
  local canUpgradeFiveLevelsHeroList = {}
  local equipHeroUuid = 0
  local isEquipHighLight = false
  local skillUpHeroUuid = 0
  local skillUpHeroSlotIndex = 0
  if team then
    for i, heroUnit in ipairs(team) do
      local heroData = heroUnit.hero or heroUnit
      local heroUuid = heroData.uuid
      local targetLv = self:HeroUpgradeLevelConditionAtLeastNum(false)
      local canUpGradeLevels = HeroUtils.CanHeroUpgradeMultipleLevels(heroData, targetLv, false)
      if canUpGradeLevels then
        table.insert(canUpgradeFiveLevelsHeroList, heroData)
      end
      local skill = heroData:GetCanUpgradeSkill()
      if skill then
        skillUpHeroUuid = heroUuid
        skillUpHeroSlotIndex = skill.slotIndex
      end
    end
    local canEquipBetter, heroUidList, isShowEquipHighLight = DataCenter.EquipDataManager:CheckHeroesEquipQualityBelowFreeEquip(team)
    if canEquipBetter then
      equipHeroUuid = self:GetHighestPriorityHeroUuidForHeroEquip(heroUidList)
      isEquipHighLight = isShowEquipHighLight
    end
  end
  local canUpgradeFiveLevelsHeroNum = #canUpgradeFiveLevelsHeroList
  local canUpgradeFiveLevelsHeroUuid = self:GetHighestPriorityHeroUuidForHeroUpgrade(canUpgradeFiveLevelsHeroList)
  return canUpgradeFiveLevelsHeroUuid, canUpgradeFiveLevelsHeroNum, equipHeroUuid, isEquipHighLight, skillUpHeroUuid, skillUpHeroSlotIndex
end

local function CheckRecruitHeroCondition(minTicketCount)
  local buildData = DataCenter.BuildManager.buildIdBuilding[RECRUIT_BUILDING_ID]
  if buildData == nil or #buildData < 1 or buildData[1].level <= 0 then
    return false
  end
  local count = DataCenter.ItemData:GetItemCount("230006")
  return count ~= nil and minTicketCount <= count
end

function BattleResultGrowthUtils.CanRecruitHero()
  return CheckRecruitHeroCondition(10)
end

function BattleResultGrowthUtils.CanRecruitHeroDefault()
  local targetNum = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k4")
  if not targetNum or targetNum <= 0 then
    return false
  end
  return CheckRecruitHeroCondition(targetNum)
end

function BattleResultGrowthUtils.CanHighlightRecruitHero()
  local targetNum = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k5")
  if not targetNum or targetNum <= 0 then
    return false
  end
  return CheckRecruitHeroCondition(targetNum)
end

function BattleResultGrowthUtils.CanTargetBuildingUpgrade(targetBuildingId, mainCityBuildingId)
  local targetBuildingData = DataCenter.BuildManager.buildIdBuilding[targetBuildingId]
  local cityData = DataCenter.BuildManager.buildIdBuilding[mainCityBuildingId]
  if cityData ~= nil and #cityData == 1 then
    if targetBuildingData ~= nil and 1 <= #targetBuildingData then
      if targetBuildingData[1].level < cityData[1].level then
        return true, targetBuildingData[1]
      else
        return false
      end
    else
      local state = DataCenter.BuildManager:GetBuildState(targetBuildingId)
      if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
        return true
      else
        return false
      end
    end
  end
  return false
end

function BattleResultGrowthUtils.CanTargetBuildingUpgradeByHeroType(team)
  if not team or #team == 0 then
    return false
  end
  local heroTypeCounts = {}
  for i, heroUnit in ipairs(team) do
    local heroData = heroUnit.hero or heroUnit
    if heroData then
      local heroType = heroData.heroType or heroData.type
      if heroType then
        heroTypeCounts[heroType] = (heroTypeCounts[heroType] or 0) + 1
      end
    end
  end
  local maxCount = 0
  local maxHeroTypes = {}
  for heroType, count in pairs(heroTypeCounts) do
    if count > maxCount then
      maxCount = count
      maxHeroTypes = {heroType}
    elseif count == maxCount then
      table.insert(maxHeroTypes, heroType)
    end
  end
  if #maxHeroTypes == 1 then
    local targetHeroType = maxHeroTypes[1]
    local buildingId = BattleResultGrowthUtils.GetBuildingIdByHeroType(targetHeroType)
    if buildingId then
      local canUpgrade, buildingData = BattleResultGrowthUtils.CanTargetBuildingUpgrade(buildingId, BuildingTypes.FUN_BUILD_MAIN)
      return canUpgrade, buildingData, targetHeroType
    end
    return false
  else
    local priorityOrder = {
      HeroType.Tank,
      HeroType.Aircraft,
      HeroType.Missile
    }
    for _, priorityType in ipairs(priorityOrder) do
      for _, heroType in ipairs(maxHeroTypes) do
        if heroType == priorityType then
          local buildingId = BattleResultGrowthUtils.GetBuildingIdByHeroType(priorityType)
          if buildingId then
            local canUpgrade, buildingData = BattleResultGrowthUtils.CanTargetBuildingUpgrade(buildingId, BuildingTypes.FUN_BUILD_MAIN)
            if canUpgrade then
              return true, buildingData, priorityType
            end
          end
        end
      end
    end
  end
  return false
end

function BattleResultGrowthUtils.GetBuildingIdByHeroType(heroType)
  if heroType == HeroType.Tank then
    return BuildingTypes.LW_BUILD_TANKCENTER
  elseif heroType == HeroType.Aircraft then
    return BuildingTypes.LW_BUILD_AIRCRAFTCENTER
  elseif heroType == HeroType.Missile then
    return BuildingTypes.LW_BUILD_ARTILLERYCENTER
  end
  return BuildingTypes.LW_BUILD_TANKCENTER
end

function BattleResultGrowthUtils.CanRadarDetect()
  return DataCenter.RadarCenterDataManager:GetUnFinishedDetectEventNum() > 0
end

function BattleResultGrowthUtils:GetHighestPriorityHeroUuidForHeroUpgrade(candidates)
  if not candidates or #candidates == 0 then
    return 0
  end
  self:SortHeroesForHeroUpgrade(candidates)
  return candidates[1].uuid
end

function BattleResultGrowthUtils:SortHeroesForHeroUpgrade(candidates)
  if not candidates or #candidates == 0 then
    return {}
  end
  table.sort(candidates, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    if a.level ~= b.level then
      return a.level < b.level
    end
    if a.power ~= b.power then
      return a.power > b.power
    end
    return a.heroId < b.heroId
  end)
end

function BattleResultGrowthUtils:GetHighestPriorityHeroUuidForHeroEquip(candidates)
  if not candidates or #candidates == 0 then
    return 0
  end
  self:SortHeroesForHeroEquip(candidates)
  return candidates[1].uuid
end

function BattleResultGrowthUtils:SortHeroesForHeroEquip(candidates)
  if not candidates or #candidates == 0 then
    return {}
  end
  table.sort(candidates, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    if a.level ~= b.level then
      return a.level > b.level
    end
    if a.power ~= b.power then
      return a.power > b.power
    end
    return a.heroId < b.heroId
  end)
end

function BattleResultGrowthUtils:GetHighestPriorityHeroUuidForHeroRank(candidates)
  if not candidates or #candidates == 0 then
    return 0
  end
  self:SortHeroesForHeroRank(candidates)
  return candidates[1].uuid
end

function BattleResultGrowthUtils:SortHeroesForHeroRank(candidates)
  if not candidates or #candidates == 0 then
    return {}
  end
  table.sort(candidates, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    if a.rank ~= b.rank then
      return a.rank < b.rank
    end
    if a.power ~= b.power then
      return a.power > b.power
    end
    return a.heroId < b.heroId
  end)
end

function BattleResultGrowthUtils:GetCanHighlightHeroUid(team)
  local targetHero
  local totalLevel = 0
  local notSRHeroCount = 0
  for i, heroUnit in ipairs(team) do
    local heroData = heroUnit.hero
    if heroData.quality > 2 then
      totalLevel = totalLevel + heroData.level
      notSRHeroCount = notSRHeroCount + 1
    end
  end
  if notSRHeroCount <= 1 or totalLevel <= 0 then
    return 0
  end
  local conditionAvgLevel = self:HeroUpgradeLevelBelowAvgConditionNum()
  local targetLevel = self:HeroUpgradeLevelConditionAtLeastNum(true)
  local candidates = {}
  for i, heroUnit in ipairs(team) do
    if heroUnit and heroUnit.hero then
      local heroData = heroUnit.hero
      if heroData.quality > 2 then
        local avgLevel = (totalLevel - heroData.level) / (notSRHeroCount - 1)
        if heroData.level < avgLevel - conditionAvgLevel then
          local canUpGradeLevels = HeroUtils.CanHeroUpgradeMultipleLevels(heroData, targetLevel, true)
          if canUpGradeLevels then
            table.insert(candidates, heroData)
          end
        end
      end
    end
  end
  if 0 < #candidates then
    return self:GetHighestPriorityHeroUuidForHeroUpgrade(candidates)
  end
  return 0
end

function BattleResultGrowthUtils:CanTeamSSRHeroesUpgradeStar(team)
  if not team or #team == 0 then
    return false, 0, 0
  end
  local canUpgrade, upgradeOnceHeroes, upgradeFullHeroes = HeroUtils.CanTeamSSRHeroesUpgradeStar(team)
  local upOnceHeroUid = 0
  local upFullHeroUid = 0
  if canUpgrade then
    if not table.IsNullOrEmpty(upgradeOnceHeroes) then
      upOnceHeroUid = self:GetHighestPriorityHeroUuidForHeroRank(upgradeOnceHeroes)
    end
    if not table.IsNullOrEmpty(upgradeFullHeroes) then
      upFullHeroUid = self:GetHighestPriorityHeroUuidForHeroRank(upgradeFullHeroes)
    end
  end
  return canUpgrade, upOnceHeroUid, upFullHeroUid
end

function BattleResultGrowthUtils:CanAdjustFormation(team, wrongCount)
  if not team or #team == 0 then
    return false
  end
  local adjustData = {}
  local wrongPositionFront, wrongPositionBack = 0, 0
  for i, heroUnit in ipairs(team) do
    local heroData = heroUnit.hero
    local slot = heroUnit.slot
    if heroData and heroData.heroJob then
      if 1 <= slot and slot <= 2 and heroData.heroJob ~= HeroJob.Defense then
        if not adjustData[1] then
          adjustData[1] = {}
          adjustData[1].slot = slot
          adjustData[1].uid = heroData.uuid
        end
        wrongPositionFront = wrongPositionFront + 1
      elseif 3 <= slot and slot <= 5 and heroData.heroJob == HeroJob.Defense then
        if not adjustData[2] then
          adjustData[2] = {}
          adjustData[2].slot = slot
          adjustData[2].uid = heroData.uuid
        end
        wrongPositionBack = wrongPositionBack + 1
      end
    end
  end
  local wrongPosCount = wrongCount or 1
  local canAdjust = wrongPositionFront >= wrongPosCount and wrongPositionBack >= wrongPosCount
  return canAdjust, adjustData
end

function BattleResultGrowthUtils:IsLevelNeedCityUpgrade(team)
  local cityData = DataCenter.BuildManager.buildIdBuilding[MAIN_CITY_BUILDING_ID]
  local hasCity = cityData ~= nil and #cityData == 1
  if not hasCity then
    return false, false
  end
  local levelNeedCityUpgrade = false
  local isCityUpgradeHighLight = false
  if team then
    levelNeedCityUpgrade = hasCity and HeroUtils.CanTeamHeroesUpgrade(team, 1)
    isCityUpgradeHighLight = hasCity and HeroUtils.CanTeamHeroesUpgrade(team, 3)
  end
  return levelNeedCityUpgrade, isCityUpgradeHighLight
end

function BattleResultGrowthUtils:HeroUpgradeLevelConditionAtLeastNum(isHighlightCondition)
  local level
  if isHighlightCondition then
    level = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k3")
  else
    level = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k1")
  end
  return level or 1
end

function BattleResultGrowthUtils:HeroUpgradeLevelBelowAvgConditionNum()
  local level = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k2")
  return level or 1
end

function BattleResultGrowthUtils:SetNeedAdjustFormationData(data)
  needAdjustFormationData = data
end

function BattleResultGrowthUtils:GetNeedAdjustFormationData()
  return needAdjustFormationData
end

function BattleResultGrowthUtils:ClearNeedAdjustFormationData()
  needAdjustFormationData = nil
end

BattleResultGrowthUtils.GrowthWayType = GrowthWayType
BattleResultGrowthUtils.SPECIAL_PREFAB_NAME = SPECIAL_PREFAB_NAME
BattleResultGrowthUtils.TANK_BUILDING_ID = TANK_BUILDING_ID
BattleResultGrowthUtils.MAIN_CITY_BUILDING_ID = MAIN_CITY_BUILDING_ID
BattleResultGrowthUtils.RECRUIT_BUILDING_ID = RECRUIT_BUILDING_ID
return BattleResultGrowthUtils
