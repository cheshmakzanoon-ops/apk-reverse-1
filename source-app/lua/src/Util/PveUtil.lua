local PveUtil = {}
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local HeroPowerCache
local ShowHeroSlotEmptyFlag = true
local ShowHeroRarityFlag = true
local ShowHeroBeyondFlag = true
local ShowHeroMaxedFlag = true
local WORLD = CS.UnityEngine.Space.World
local UP = Vector3.up
local cannonWorldForward = Vector3.zero
local Epsilon = 1.0E-4
local CheckFlag = {
  None = 0,
  HeroSlotEmpty = 1,
  HeroRarity = 2,
  HeroBeyond = 4,
  HeroMaxed = 8,
  All = 2147483647
}

local function GetCheckFlag()
  local levelType = DataCenter.BattleLevel:GetLevelType()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  local flag = CheckFlag.None
  if levelType == PveLevelType.NormalLevel then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity
  elseif levelType == PveLevelType.HeroExpLevel then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity | CheckFlag.HeroMaxed
  elseif levelType == PveLevelType.BattleExpLevel then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity | CheckFlag.HeroMaxed
  elseif levelType == PveLevelType.RadarExpLevel then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity | CheckFlag.HeroMaxed
  elseif levelType == PveLevelType.FightLevel and entranceType == PveEntrance.LandLock then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity
  elseif levelType == PveLevelType.FightLevel and entranceType == PveEntrance.DetectEventPve then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity
  elseif levelType == PveLevelType.FightLevel and entranceType == PveEntrance.AdventureSetting then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity
  elseif levelType == PveLevelType.FightLevel and entranceType == PveEntrance.ArenaSetting then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity
  elseif levelType == PveLevelType.FightLevel and entranceType == PveEntrance.MineCave then
    flag = CheckFlag.HeroSlotEmpty
  elseif levelType == PveLevelType.FightLevel and entranceType == PveEntrance.Test then
    flag = CheckFlag.HeroSlotEmpty | CheckFlag.HeroRarity
  end
  print("beef GetCheckFlag flag: " .. flag)
  return flag
end

local function CheckConfigChanged()
  local k3 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k3") or ""
  local k4 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k4") or ""
  local k5 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k5") or ""
  local k6 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k6") or ""
  local str = k3 .. k4 .. k5 .. k6
  local cacheStr = Setting:GetString(SettingKeys.PVE_HERO_POWER_CONFIG_CACHE .. LuaEntry.Player.uid, "")
  if str ~= cacheStr then
    Setting:SetString(SettingKeys.PVE_HERO_POWER_CONFIG_CACHE .. LuaEntry.Player.uid, str)
    PveUtil.ClearHeroPowerCache()
  end
end

local function LoadHeroPowerCache()
  HeroPowerCache = {}
  local cacheStr = Setting:GetString(SettingKeys.PVE_HERO_POWER_CACHE .. LuaEntry.Player.uid, "")
  if cacheStr == "" then
    return
  end
  local strs = string.split(cacheStr, "|")
  for _, str in ipairs(strs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local key = tostring(spls[1])
      local val = tonumber(spls[2])
      HeroPowerCache[key] = val
    end
  end
end

local function SaveHeroPowerCache()
  local strs = {}
  for key, val in pairs(HeroPowerCache) do
    local str = key .. ";" .. val
    table.insert(strs, str)
  end
  local cacheStr = string.join(strs, "|")
  Setting:SetString(SettingKeys.PVE_HERO_POWER_CACHE .. LuaEntry.Player.uid, cacheStr)
end

local function GetHeroPowerCache(key)
  if HeroPowerCache == nil then
    PveUtil.LoadHeroPowerCache()
  end
  return HeroPowerCache[key]
end

local function SetHeroPowerCache(key, val)
  if HeroPowerCache == nil then
    PveUtil.LoadHeroPowerCache()
  end
  HeroPowerCache[key] = val
end

local function ClearHeroPowerCache()
  Setting:SetString(SettingKeys.PVE_HERO_POWER_CACHE .. LuaEntry.Player.uid, "")
  HeroPowerCache = {}
end

local function GetCacheKey(heroDataDict)
  local heroUuidList = table.keys(heroDataDict)
  table.sort(heroUuidList)
  local key = string.join(heroUuidList, ";")
  return key
end

local function GetRecommendMonsterId(diff)
  local k3 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k3") or ""
  local k4 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k4") or ""
  local k3Strs = string.split(k3, "|")
  local k4Strs = string.split(k4, "|")
  local x, y, startId, endId
  if k3Strs[diff] == nil then
    return nil
  end
  local xySpls = string.split(k3Strs[diff], ";")
  if #xySpls == 2 then
    x = tonumber(xySpls[1])
    y = tonumber(xySpls[2])
  end
  if x == nil or y == nil then
    return nil
  end
  if #k4Strs == 2 then
    startId = tonumber(k4Strs[1])
    endId = tonumber(k4Strs[2])
  end
  if startId == nil or endId == nil then
    return nil
  end
  local originHeroDataList = DataCenter.HeroDataManager:GetHeroSortList()
  table.sort(originHeroDataList, function(heroA, heroB)
    local heroPowerA = PveUtil.GetHeroPower({
      [heroA.uuid] = heroA
    })
    local heroPowerB = PveUtil.GetHeroPower({
      [heroB.uuid] = heroB
    })
    if heroPowerA ~= heroPowerB then
      return heroPowerA > heroPowerB
    else
      return heroA.heroId < heroB.heroId
    end
  end)
  local heroDataList = {}
  for _, heroData in ipairs(originHeroDataList) do
    if x <= #heroDataList then
      break
    end
    if heroData.level < heroData.finalLevel and heroData.level < heroData.curMaxLevel then
      table.insert(heroDataList, heroData)
    end
  end
  if #heroDataList == 0 then
    table.insert(heroDataList, originHeroDataList[1])
  end
  local originPower = math.floor(PveUtil.GetAverageHeroPower(heroDataList))
  local power = math.floor(originPower * (1 + y))
  local selectId = startId
  local min = IntMaxValue
  for id = startId, endId do
    local recommendPower = tonumber(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), id, "recommend_power")) or -1
    if min > math.abs(power - recommendPower) then
      min = math.abs(power - recommendPower)
      selectId = id
    end
  end
  PveUtil.SaveHeroPowerCache()
  return selectId
end

local function GetAverageHeroPower(heroDataList)
  local power = 0
  if #heroDataList == 0 then
    return 0
  elseif #heroDataList == 1 then
    local dict = {}
    dict[heroDataList[1].uuid] = heroDataList[1]
    power = power + PveUtil.GetHeroPower(dict)
  else
    if #heroDataList % 2 == 1 then
      local m = #heroDataList // 2 + 1
      table.remove(heroDataList, m)
    end
    local dict = {}
    local count = 0
    for _, heroData in ipairs(heroDataList) do
      dict[heroData.uuid] = heroData
      if table.count(dict) == 2 then
        power = power + PveUtil.GetHeroPower(dict)
        count = count + 1
        dict = {}
      end
    end
    power = power / count
  end
  return power
end

local function GetHeroPower(heroDataDict)
  local key = PveUtil.GetCacheKey(heroDataDict)
  if PveUtil.GetHeroPowerCache(key) ~= nil then
    return PveUtil.GetHeroPowerCache(key)
  end
  local army = PveActorMgr:GetInstance():GetArmyDataForHeroExpBattleLevel(heroDataDict)
  local power = MarchUtil.GetFormationPower(heroDataDict, army, 1, MarchUtil.GetCampAddParam(heroDataDict))
  PveUtil.SetHeroPowerCache(key, power)
  return power
end

local function GetRecommendLevelLimitMonsterId()
  local k4 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k4") or ""
  local k5 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k5") or ""
  local k4Strs = string.split(k4, "|")
  local k5Strs = string.split(k5, ";")
  local x, y, startId, endId
  if #k5Strs == 2 then
    x = tonumber(k5Strs[1])
    y = tonumber(k5Strs[2])
  end
  if x == nil or y == nil then
    return nil
  end
  if #k4Strs == 2 then
    startId = tonumber(k4Strs[1])
    endId = tonumber(k4Strs[2])
  end
  if startId == nil or endId == nil then
    return nil
  end
  local originHeroDataList = DataCenter.HeroDataManager:GetHeroSortList()
  table.sort(originHeroDataList, function(heroA, heroB)
    local heroPowerA = PveUtil.GetHeroPower({
      [heroA.uuid] = heroA
    })
    local heroPowerB = PveUtil.GetHeroPower({
      [heroB.uuid] = heroB
    })
    if heroPowerA ~= heroPowerB then
      return heroPowerA > heroPowerB
    else
      return heroA.heroId < heroB.heroId
    end
  end)
  local heroDataList = {}
  for _, heroData in ipairs(originHeroDataList) do
    if x <= #heroDataList then
      break
    end
    if heroData.level < heroData.finalLevel and heroData.level <= DataCenter.BattleLevel:GetMaxHeroLevel() then
      table.insert(heroDataList, heroData)
    end
  end
  if #heroDataList == 0 then
    table.insert(heroDataList, originHeroDataList[1])
  end
  local originPower = PveUtil.GetAverageHeroPower(heroDataList)
  local power = originPower * (1 + y)
  local selectId = startId
  local min = IntMaxValue
  for id = startId, endId do
    local recommendPower = tonumber(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), id, "recommend_power")) or -1
    if min > math.abs(power - recommendPower) then
      min = math.abs(power - recommendPower)
      selectId = id
    end
  end
  PveUtil.SaveHeroPowerCache()
  return selectId
end

local function CheckHeroesBreak(heroUuidList, OnContinue)
  if GetCheckFlag() & CheckFlag.HeroBeyond ~= 0 then
    for _, heroUuid in ipairs(heroUuidList) do
      if PveUtil.CheckHeroBreak(heroUuid, OnContinue) then
        return
      end
    end
  end
  if OnContinue then
    OnContinue()
  end
end

local function CheckHeroBreak(heroUuid, OnContinue)
  local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
  if heroData ~= nil and heroData:CanBeyond() and ShowHeroBeyondFlag then
    local name = HeroUtils.GetHeroNameByConfigId(heroData.heroId)
    UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("400082", name), 2, GameDialogDefine.GOTO, GameDialogDefine.CONTINUE, function()
      DataCenter.HeroDataManager:BeyondHero(heroUuid)
    end, function(show)
      ShowHeroBeyondFlag = show
    end, OnContinue)
    return true
  end
  return false
end

local function CheckHeroesMaxed(heroUuidList, OnContinue)
  if GetCheckFlag() & CheckFlag.HeroMaxed ~= 0 then
    for _, heroUuid in ipairs(heroUuidList) do
      if PveUtil.CheckHeroMaxed(heroUuid, OnContinue) then
        return
      end
    end
  end
  if OnContinue then
    OnContinue()
  end
end

local function CheckHeroMaxed(heroUuid, OnContinue)
  local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
  if heroData ~= nil and heroData.level >= heroData.finalLevel and ShowHeroMaxedFlag then
    local name = HeroUtils.GetHeroNameByConfigId(heroData.heroId)
    UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("400072", name), 2, GameDialogDefine.CANCEL, GameDialogDefine.CONTINUE, nil, function(show)
      ShowHeroMaxedFlag = show
    end, OnContinue)
    return true
  end
  return false
end

local function CheckHeroesRarity(heroUuidList, OnConfirm)
  if GetCheckFlag() & CheckFlag.HeroRarity ~= 0 then
    for _, heroUuid in ipairs(heroUuidList) do
      if PveUtil.CheckHeroRarity(heroUuidList, heroUuid, OnConfirm) then
        return
      end
    end
  end
  if OnConfirm then
    OnConfirm()
  end
end

local function CheckHeroRarity(heroUuidList, heroUuid, OnConfirm)
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  local maxHeroLevel = DataCenter.BattleLevel:GetMaxHeroLevel()
  local heroDataList = DataCenter.HeroDataManager:GetHeroSortList()
  local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
  if heroData ~= nil then
    for _, v in ipairs(heroDataList) do
      if v.uuid ~= heroUuid and v.rarity < heroData.rarity and not table.hasvalue(heroUuidList, v.uuid) and maxHeroLevel >= v.level and (entranceType ~= PveEntrance.MineCave or not DataCenter.MineCaveManager:CheckIfHeroIsBusy(v.heroId)) and ShowHeroRarityFlag then
        UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("400054"), 2, "400085", GameDialogDefine.CONTINUE, nil, function(show)
          ShowHeroRarityFlag = show
        end, OnConfirm)
        return true
      end
    end
  end
  return false
end

local function CheckHeroSlotEmpty(curCount, maxCount, OnConfirm)
  if GetCheckFlag() & CheckFlag.HeroSlotEmpty ~= 0 then
    local totalCount = table.count(DataCenter.HeroDataManager:GetAllHeroList())
    if curCount < maxCount and curCount < totalCount and ShowHeroSlotEmptyFlag then
      UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("400081"), 2, "400083", GameDialogDefine.CONTINUE, nil, function(show)
        ShowHeroSlotEmptyFlag = show
      end, OnConfirm)
      return
    end
  end
  if OnConfirm then
    OnConfirm()
  end
end

local function ParseArmyRecord(serverData)
  if string.IsNullOrEmpty(serverData) then
    return nil
  end
  local total, alive, dead = {}, {}, {}
  local totalCount, aliveCount, deadCount = 0, 0, 0
  local records = string.split(serverData, ",")
  local totalRecord, deadRecord = records[1], records[2]
  if totalRecord then
    local strs = string.split(totalRecord, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        local armsId = tonumber(spls[1])
        local count = tonumber(spls[2])
        total[armsId] = count
        totalCount = totalCount + count
      end
    end
  end
  if deadRecord then
    local strs = string.split(deadRecord, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        local armsId = tonumber(spls[1])
        local count = tonumber(spls[2])
        dead[armsId] = count
        deadCount = deadCount + count
      end
    end
  end
  for armsId, _ in pairs(total) do
    local count = total[armsId] - (dead[armsId] or 0)
    if 0 < count then
      alive[armsId] = count
      aliveCount = aliveCount + count
    end
  end
  local record = {
    total = total,
    alive = alive,
    dead = dead,
    totalCount = totalCount,
    aliveCount = aliveCount,
    deadCount = deadCount
  }
  return record
end

local function CanShowPowerLack(param)
  local lackType = PveUtil.GetPowerLack(param)
  return lackType ~= PvePowerLackType.None
end

local function GetPowerLack(param)
  local tips = {}
  local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(param.monsterId)
  local needPower = monsterTemplate.recommend_power
  local needArmy = monsterTemplate.needArmy
  local needHero = monsterTemplate.needHero
  local armyCount = 0
  for id, count in pairs(param.armyDict) do
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
    if template.level >= needArmy.level then
      armyCount = armyCount + count
    end
  end
  if armyCount < needArmy.count then
    for _, tip in ipairs(PvePowerLackShowTips[PvePowerLackType.Army]) do
      local template = DataCenter.ResLackManager:GetTemplateByTip(tip)
      if template and template:CheckMainLevelAndPlayerLevel() then
        table.insert(tips, tip)
      end
    end
  end
  if 0 < #tips then
    return PvePowerLackType.Army, tips
  end
  local heroCount = 0
  for _, heroUuid in ipairs(param.heroUuidList) do
    local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
    if heroData.level >= needHero.level then
      heroCount = heroCount + 1
    end
  end
  if heroCount < needHero.count then
    for _, tip in ipairs(PvePowerLackShowTips[PvePowerLackType.Hero]) do
      local template = DataCenter.ResLackManager:GetTemplateByTip(tip)
      if template and template:CheckMainLevelAndPlayerLevel() then
        table.insert(tips, tip)
      end
    end
  end
  if 0 < #tips then
    return PvePowerLackType.Hero, tips
  end
  if needPower > param.power then
    for _, tip in ipairs(PvePowerLackShowTips[PvePowerLackType.Power]) do
      local template = DataCenter.ResLackManager:GetTemplateByTip(tip)
      if template and template:CheckMainLevelAndPlayerLevel() then
        table.insert(tips, tip)
      end
    end
  end
  if 0 < #tips then
    return PvePowerLackType.Power, tips
  end
  return PvePowerLackType.None, tips
end

local function GetPowerLackTipClickFunc(param)
  local trigger = PveActorMgr:GetInstance():GetCurTrigger()
  if trigger == nil then
    return nil
  end
  local monsterId = tonumber(GetTableData(TableName.PVETrigger, trigger:GetTriggerId(), "UnclockPara")) or 0
  local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if monsterTemplate == nil then
    return nil
  end
  local armyDict = PveActorMgr:GetInstance():GetArmys() or {}
  local func
  local needExitBattle = false
  if param.lackType == PvePowerLackType.Fail then
    needExitBattle = true
  end
  local heroUuidList = DeepCopy(param.heroUuidList)
  table.sort(heroUuidList, function(heroUuidA, heroUuidB)
    local heroDataA = DataCenter.HeroDataManager:GetHeroByUuid(heroUuidA)
    local heroDataB = DataCenter.HeroDataManager:GetHeroByUuid(heroUuidB)
    if heroDataA.rarity ~= heroDataB.rarity then
      return heroDataA.rarity < heroDataB.rarity
    elseif heroDataA.level ~= heroDataB.level then
      return heroDataA.level > heroDataB.level
    else
      return heroDataA.heroId < heroDataB.heroId
    end
  end)
  
  local function GoHeroList()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroList, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, false, function()
      for _, heroUuid in ipairs(heroUuidList) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        PveActorMgr:GetInstance():SetModelHeroLv(heroData.heroId, heroData.level)
      end
      UIUtil.PveSceneHeroListRefresh()
    end)
  end
  
  if param.tip == PvePowerLackTipType.HeroExpBook then
    func = GoHeroList
  elseif param.tip == PvePowerLackTipType.HeroExpOrBeyond then
    func = GoHeroList
  elseif param.tip == PvePowerLackTipType.HeroExpMonster then
    needExitBattle = true
    
    function func()
      if DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_1) then
        SceneUtils.ChangeToWorld(function()
          local level = math.max(1, DataCenter.MonsterManager:GetCurCanAttackMaxLevel() - 1)
          GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Monster, level)
        end)
      else
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
      end
    end
  elseif param.tip == PvePowerLackTipType.HeroUpgradeStar then
    func = GoHeroList
  elseif param.tip == PvePowerLackTipType.HeroUpgradeSkill then
    func = GoHeroList
  elseif param.tip == PvePowerLackTipType.TrainUnit then
    local count = 0
    for _, v in pairs(armyDict) do
      count = count + v
    end
    local maxCount = PveUtil.GetMaxSoldierNum(heroUuidList)
    if count < maxCount then
      needExitBattle = true
      
      function func()
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK, WorldTileBtnType.City_TrainingInfantry)
      end
    end
  elseif param.tip == PvePowerLackTipType.HeroHigherLevel then
    local toHeroUuid
    local toLevel = IntMinValue
    for _, heroUuid in ipairs(heroUuidList) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData and toLevel < heroData.level then
        toLevel = heroData.level
      end
    end
    for heroUuid, heroData in pairs(DataCenter.HeroDataManager:GetAllHeroList()) do
      if toLevel < heroData.level then
        toHeroUuid = heroUuid
        toLevel = heroData.level
      end
    end
    if toHeroUuid then
      function func()
        UIUtil.PveSceneHeroListScrollToHero(toHeroUuid)
      end
    end
  elseif param.tip == PvePowerLackTipType.HeroHigherPower then
    local toHeroUuid
    local toPower = IntMinValue
    for _, heroUuid in ipairs(heroUuidList) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData and toPower < heroData.power then
        toPower = heroData.power
      end
    end
    for heroUuid, heroData in pairs(DataCenter.HeroDataManager:GetAllHeroList()) do
      if toPower < heroData.power then
        toHeroUuid = heroUuid
        toPower = heroData.power
      end
    end
    if toHeroUuid then
      function func()
        UIUtil.PveSceneHeroListScrollToHero(toHeroUuid)
      end
    end
  elseif param.tip == PvePowerLackTipType.HeroBeyond then
    func = GoHeroList
  elseif param.tip == PvePowerLackTipType.FirstPay then
    if DataCenter.PayManager:CheckIfFirstPayOpen() then
      function func()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, {
          anim = false,
          
          UIMainAnim = UIMainAnimType.AllHide
        })
      end
    end
  elseif param.tip == PvePowerLackTipType.MainQuest then
    needExitBattle = true
    
    function func()
      DataCenter.ChapterTaskCellManager:SetPvePowerState(true)
    end
  end
  if func then
    if needExitBattle then
      return function()
        DataCenter.BattleLevel:Exit(func)
        if param.closeFunc then
          param.closeFunc()
        end
      end
    else
      return function()
        func()
        if param.closeFunc then
          param.closeFunc()
        end
      end
    end
  end
  return nil
end

local function GetMaxSoldierNum(heroUuidList)
  local asPlayerMaxSoldiers = LuaEntry.DataConfig:TryGetNum("building_base", "k5")
  local baseSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE)
  local sizeEnhance = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + math.floor(baseSize + 0.5)
  local campAdd = 0
  if heroUuidList then
    for _, heroUuid in ipairs(heroUuidList) do
      local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
      if heroData ~= nil then
        local config = heroData:GetConfig()
        local rankId = heroData:GetRank()
        local armyAdd = HeroUtils.GetArmyLimit(heroData.level, rankId, config.rarity, heroData.heroId, heroData.quality)
        asPlayerMaxSoldiers = asPlayerMaxSoldiers + armyAdd
        local heroBaseSize = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE)
        local heroSizeEnhance = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
        local campAddEffect = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraTroopByCamp(heroData.camp))
        campAdd = campAddEffect + campAdd
        asPlayerMaxSoldiers = asPlayerMaxSoldiers + heroBaseSize
        sizeEnhance = sizeEnhance + heroSizeEnhance
      end
    end
  end
  local formationIndex = 1
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local _, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
    local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    formationIndex = formationInfo.index
  end
  local finalAddNumByIndex = MarchUtil.GetFormationMaxNumByFormationIndex(formationIndex)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + finalAddNumByIndex + campAdd
  asPlayerMaxSoldiers = asPlayerMaxSoldiers * (1 + sizeEnhance / 100)
  return math.floor(asPlayerMaxSoldiers)
end

local log_table = {}
local Log_String
local Log_Format = [[

[%s]=%s]]
local Log_Format_2 = "[%s]=%s,"

local function DamageLog(damage)
end

local DAMAGE_PARAM

local function CalculateHP(defender)
  ProfilerUtil.BeginSample("CalculateHP")
  if defender.maxBlood and type(defender.maxBlood) == "number" and defender.maxBlood > 0 then
    return defender.maxBlood
  end
  local HealthPoint = defender:GetProperty(HeroEffectDefine.HealthPoint)
  local HpAddRate = defender:GetProperty(HeroEffectDefine.HpAddRate)
  local hp = HealthPoint * (1 + HpAddRate)
  local EquipHealthPoint = defender:GetProperty(HeroEffectDefine.EquipHealthPoint)
  hp = hp + EquipHealthPoint
  local BuffHpAddRate = defender:GetProperty(HeroEffectDefine.BuffHpAddRate)
  hp = hp * (1 + BuffHpAddRate)
  ProfilerUtil.EndSample()
  return hp
end

local function CalculateAttack(attacker)
  local PhysicalAttack = attacker:GetProperty(HeroEffectDefine.PhysicalAttack)
  local AllAttackAddRate = attacker:GetProperty(HeroEffectDefine.AllAttackAddRate)
  local camp = attacker:GetHeroCamp()
  local CampAttackAddRate, BuildingAttack
  if camp == HeroType.None then
    CampAttackAddRate = 0
    BuildingAttack = 0
  elseif camp == HeroType.Tank then
    CampAttackAddRate = attacker:GetProperty(HeroEffectDefine.TankAttackAddRate)
    BuildingAttack = attacker:GetProperty(HeroEffectDefine.TankBuildingAttack)
  elseif camp == HeroType.Missile then
    CampAttackAddRate = attacker:GetProperty(HeroEffectDefine.MissileAttackAddRate)
    BuildingAttack = attacker:GetProperty(HeroEffectDefine.MissileBuildingAttack)
  else
    CampAttackAddRate = attacker:GetProperty(HeroEffectDefine.AircraftAttackAddRate)
    BuildingAttack = attacker:GetProperty(HeroEffectDefine.AircraftBuildingAttack)
  end
  local attack = PhysicalAttack * (1 + AllAttackAddRate + CampAttackAddRate)
  local EquipPhysicalAttack = attacker:GetProperty(HeroEffectDefine.EquipPhysicalAttack)
  attack = attack + EquipPhysicalAttack
  attack = attack + BuildingAttack
  local BuffAttackAddRate = attacker:GetProperty(HeroEffectDefine.BuffAttackAddRate)
  local BuffAttackReduceRate = attacker:GetProperty(HeroEffectDefine.BuffAttackReduceRate)
  local LineupAttackAddRate = attacker:GetProperty(HeroEffectDefine.LineupAttackAddRate)
  attack = attack * (1 + BuffAttackAddRate - BuffAttackReduceRate + LineupAttackAddRate)
  return attack
end

function PveUtil.CalculateAttackAndAddDamage(attacker)
  ProfilerUtil.BeginSample("CalculateAttackAndAddDamage")
  local attack = CalculateAttack(attacker)
  local camp = attacker:GetHeroCamp()
  local CampDamageAddRate
  if camp == HeroType.None then
    CampDamageAddRate = 0
  elseif camp == HeroType.Tank then
    CampDamageAddRate = attacker:GetProperty(HeroEffectDefine.TankDamageAddRate)
  elseif camp == HeroType.Missile then
    CampDamageAddRate = attacker:GetProperty(HeroEffectDefine.MissileDamageAddRate)
  else
    CampDamageAddRate = attacker:GetProperty(HeroEffectDefine.AircraftDamageAddRate)
  end
  local SkillAllDamageAddRate = attacker:GetProperty(HeroEffectDefine.SkillAllDamageAddRate)
  local AttackAgainstZombieAddRate = attacker:GetProperty(HeroEffectDefine.AttackAgainstZombieAddRate)
  local SkillDamageReduceRate = attacker:GetProperty(HeroEffectDefine.SkillDamageReduceRate)
  local addDamageBase = SkillAllDamageAddRate + AttackAgainstZombieAddRate + CampDamageAddRate - SkillDamageReduceRate
  local SkillPhysicalDamageAddRate = attacker:GetProperty(HeroEffectDefine.SkillPhysicalDamageAddRate)
  local SkillPhysicalDamageReduceRate = attacker:GetProperty(HeroEffectDefine.SkillPhysicalDamageReduceRate)
  local addDamagePhysics = addDamageBase + SkillPhysicalDamageAddRate - SkillPhysicalDamageReduceRate
  local SkillMagicDamageAddRate = attacker:GetProperty(HeroEffectDefine.SkillMagicDamageAddRate)
  local SkillMagicDamageReduceRate = attacker:GetProperty(HeroEffectDefine.SkillMagicDamageReduceRate)
  local addDamageMagic = addDamageBase + SkillMagicDamageAddRate - SkillMagicDamageReduceRate
  local critical
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    critical = attacker:GetCritProperty()
  else
    critical = attacker:GetProperty(HeroEffectDefine.CriticalRate_Result)
  end
  local criticalDamage = attacker:GetProperty(HeroEffectDefine.CriticalDamage_Result)
  ProfilerUtil.EndSample()
  return attack, addDamagePhysics, addDamageMagic, critical, criticalDamage
end

local function CalculateDefence(defender)
  local PhysicalDefense = defender:GetProperty(HeroEffectDefine.PhysicalDefense)
  local AllDefenseAddRate = defender:GetProperty(HeroEffectDefine.AllDefenseAddRate)
  local camp = defender:GetHeroCamp()
  local CampDefenseAddRate, BuildingDefense
  if camp == HeroType.None then
    CampDefenseAddRate = 0
    BuildingDefense = 0
  elseif camp == HeroType.Tank then
    CampDefenseAddRate = defender:GetProperty(HeroEffectDefine.TankDefenseAddRate)
    BuildingDefense = defender:GetProperty(HeroEffectDefine.TankBuildingDefense)
  elseif camp == HeroType.Missile then
    CampDefenseAddRate = defender:GetProperty(HeroEffectDefine.MissileDefenseAddRate)
    BuildingDefense = defender:GetProperty(HeroEffectDefine.MissileBuildingDefense)
  else
    CampDefenseAddRate = defender:GetProperty(HeroEffectDefine.AircraftDefenseAddRate)
    BuildingDefense = defender:GetProperty(HeroEffectDefine.AircraftBuildingDefense)
  end
  local defence = PhysicalDefense * (1 + AllDefenseAddRate + CampDefenseAddRate)
  local EquipPhysicalDefense = defender:GetProperty(HeroEffectDefine.EquipPhysicalDefense)
  defence = defence + EquipPhysicalDefense
  defence = defence + BuildingDefense
  local BuffDefenseAddRate = defender:GetProperty(HeroEffectDefine.BuffDefenseAddRate)
  local BuffDefenseReduceRate = defender:GetProperty(HeroEffectDefine.BuffDefenseReduceRate)
  local LineupDefenseAddRate = defender:GetProperty(HeroEffectDefine.LineupDefenseAddRate)
  defence = defence * (1 + BuffDefenseAddRate - BuffDefenseReduceRate + LineupDefenseAddRate)
  return defence
end

function PveUtil.CalculateDefenceAndReduceDamage(defender)
  ProfilerUtil.BeginSample("CalculateDefenceAndReduceDamage")
  local defence = CalculateDefence(defender)
  local SkillTakenDamageAddRate = defender:GetProperty(HeroEffectDefine.SkillTakenDamageAddRate)
  local SkillTakenDamageReduceRate = defender:GetProperty(HeroEffectDefine.SkillTakenDamageReduceRate)
  local DefenceAgainstZombieReduceRate = defender:GetProperty(HeroEffectDefine.DefenceAgainstZombieReduceRate)
  local reduceDamageBase = SkillTakenDamageAddRate - SkillTakenDamageReduceRate - DefenceAgainstZombieReduceRate
  local SkillPhysicalTakenDamageReduceRate = defender:GetProperty(HeroEffectDefine.SkillPhysicalTakenDamageReduceRate)
  local SkillPhysicalTakenDamageAddRate = defender:GetProperty(HeroEffectDefine.SkillPhysicalTakenDamageAddRate)
  local reduceDamagePhysics = reduceDamageBase + SkillPhysicalTakenDamageAddRate - SkillPhysicalTakenDamageReduceRate
  local SkillMagicTakenDamageReduceRate = defender:GetProperty(HeroEffectDefine.SkillMagicTakenDamageReduceRate)
  local SkillMagicTakenDamageAddRate = defender:GetProperty(HeroEffectDefine.SkillMagicTakenDamageAddRate)
  local reduceDamageMagic = reduceDamageBase + SkillMagicTakenDamageAddRate - SkillMagicTakenDamageReduceRate
  local EquipDamageReduceRateBase = defender:GetProperty(HeroEffectDefine.EquipDamageReduceRateBase)
  local EquipDamageReduceRatePhysics = defender:GetProperty(HeroEffectDefine.EquipDamageReduceRatePhysics)
  local EquipDamageReduceRateMagic = defender:GetProperty(HeroEffectDefine.EquipDamageReduceRateMagic)
  ProfilerUtil.EndSample()
  return defence, reduceDamagePhysics, reduceDamageMagic, EquipDamageReduceRateBase + EquipDamageReduceRatePhysics, EquipDamageReduceRateBase + EquipDamageReduceRateMagic
end

local function CalculateDamage(attacker, defender, damageType, damageMultiplier, exType, exValue, isCritical, percentDamage)
  if not DAMAGE_PARAM then
    DAMAGE_PARAM = LuaEntry.DataConfig:TryGetNum("damege_params", "k1")
  end
  local damage = 0
  local exDamage = 0
  local attack, addDamagePhysics, addDamageMagic, criticalRate, criticalDamageProperty
  if exType then
    if exType == ExDamageType.attackPercent then
      attack, addDamagePhysics, addDamageMagic, criticalRate, criticalDamageProperty = attacker:GetAttackAndAddDamageBase()
      exDamage = attack * exValue
    elseif exType == ExDamageType.hpPercent then
      local hp = CalculateHP(defender)
      exDamage = hp * exValue
    end
  end
  if damageMultiplier <= 0 then
    return exDamage, false, false, exDamage
  end
  local accuracy = attacker:GetChanceToHit()
  local rand = math.random()
  if accuracy < rand then
    if exDamage <= 0 then
      return 0, false, true, 0
    else
      return exDamage, false, false, exDamage
    end
  end
  if not attack then
    attack, addDamagePhysics, addDamageMagic, criticalRate, criticalDamageProperty = attacker:GetAttackAndAddDamageBase()
  end
  local defence, reduceDamagePhysics, reduceDamageMagic, equipDamageReducePhysics, equipDamageReduceMagic = defender:GetDefenceAndReduceDamageBase()
  local reduceDamage, addDamage, equipReduce
  if damageType == DamageType.Physics then
    reduceDamage = reduceDamagePhysics
    addDamage = addDamagePhysics
    equipReduce = equipDamageReducePhysics
  else
    reduceDamage = reduceDamageMagic
    addDamage = addDamageMagic
    equipReduce = equipDamageReduceMagic
  end
  reduceDamage = math.max(reduceDamage, -0.75)
  addDamage = math.max(addDamage, 0)
  local criticalDamage = 1
  local critical = criticalRate
  local _isCritical = isCritical
  if _isCritical == nil then
    _isCritical = critical > math.random()
  end
  if _isCritical then
    criticalDamage = criticalDamageProperty
  end
  damage = attack * attack / (attack + defence * DAMAGE_PARAM) * damageMultiplier * criticalDamage * (1 + reduceDamage) * (1 - equipReduce) * (1 + addDamage) + exDamage
  if percentDamage and 0 < percentDamage then
    local hp = CalculateHP(defender)
    local percentDamageValue = hp * percentDamage
    if damage < percentDamageValue then
      damage = percentDamageValue
    end
  end
  local nakedDamage = attack * damageMultiplier * criticalDamage * (1 + addDamage) + exDamage
  return math.ceil(damage), _isCritical, false, math.ceil(nakedDamage)
end

local function GetAllUnitsInSphereRange(battleMgr, center, radius, layerMask, exclusions, searchType)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  local ret = {}
  local hasExclusions = exclusions ~= nil
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if (not searchType or obj == nil or obj.searchType == nil or obj.searchType & searchType ~= 0) and obj ~= nil and 0 < obj:GetCurBlood() and (not hasExclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      table.insert(ret, obj)
    end
  end
  return ret
end

local function CheckHasUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions, n, searchType)
  n = n or 1
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if n > cnt then
    return false
  end
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and obj:GetCurBlood() > 0 and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() and (not searchType or 0 < obj.searchType & searchType) then
      n = n - 1
      if n == 0 then
        return obj
      end
    end
  end
  return false
end

local function FindRandomUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if cnt <= 0 then
    return false
  end
  local index = math.random(cnt)
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(index)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      return obj
    end
    index = index + 1
    if cnt < index then
      index = 1
    end
  end
  return false
end

local function FindUnitInSectorRange(battleMgr, center, minRadius, radius, layerMask, exclusions, forward, halfAngle)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if cnt <= 0 then
    return nil
  end
  local minDist = 1000000
  local nearest
  local cosHalfAngle = Mathf.Cos(halfAngle * Mathf.Deg2Rad)
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local objPos = obj:GetPosition()
      local diff = objPos - center
      local dir = diff.normalized
      local dot = Vector3.Dot(forward, dir)
      diff:ReturnPool()
      dir:ReturnPool()
      if cosHalfAngle <= dot then
        if minRadius <= 0 then
          return obj
        end
        local dist = Vector3.ManhattanDistanceXZ(objPos, center)
        if minRadius < dist and minDist > dist then
          minDist = dist
          nearest = obj
        end
      end
    end
  end
  return nearest
end

local function FindNearestUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions, targetPos)
  local cnt
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask, true, targetPos or center)
  else
    cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  end
  if cnt <= 0 then
    return nil
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    local minObjectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(1)
    local minObj = battleMgr:GetUnit(minObjectId)
    if minObj ~= nil and 0 < minObj:GetCurBlood() and (not exclusions or not exclusions[minObj.guid]) and not minObj:IsUntargetable() then
      return minObj
    end
  end
  targetPos = targetPos or center
  local nearest
  local minDist = 1000000
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local dist = Vector3.ManhattanDistanceXZ(obj:GetPosition(), targetPos)
      if minDist > dist then
        minDist = dist
        nearest = obj
        if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and PvePhysicsUtil.useCollider2D ~= true then
          break
        end
      end
    end
  end
  return nearest
end

local function FindFarthestUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions, targetPos)
  local cnt
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask, true, targetPos or center)
  else
    cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  end
  if cnt <= 0 then
    return nil
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    local maxObjectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(cnt)
    local maxObj = battleMgr:GetUnit(maxObjectId)
    if maxObj ~= nil and 0 < maxObj:GetCurBlood() and (not exclusions or not exclusions[maxObj.guid]) and not maxObj:IsUntargetable() then
      return maxObj
    end
  end
  targetPos = targetPos or center
  local farthest
  local maxDist = 0
  for i = cnt, 1, -1 do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local dist = Vector3.Distance(obj:GetPosition(), targetPos)
      if maxDist < dist then
        maxDist = dist
        farthest = obj
        if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and PvePhysicsUtil.useCollider2D ~= true then
          break
        end
      end
    end
  end
  return farthest
end

local function FindLowestHPUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if cnt <= 0 then
    return nil
  end
  local lowest
  local lowestHP = 1000000
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local blood = obj:GetCurBlood()
      if lowestHP > blood then
        lowestHP = blood
        lowest = obj
      end
    end
  end
  return lowest
end

local function FindHighestMaxHPUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if cnt <= 0 then
    return nil
  end
  local highest
  local highestHP = 0
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local blood = obj:GetMaxBlood()
      if highestHP < blood then
        highestHP = blood
        highest = obj
      end
    end
  end
  return highest
end

local function FindHighestPropertyUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions, propertyType)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if cnt <= 0 then
    return nil
  end
  local highest
  local highestProperty = 0
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local property = obj:GetProperty(propertyType)
      if highestProperty < property then
        highestProperty = property
        highest = obj
      end
    end
  end
  return highest
end

local function FindHighestBuffCountUnitInSphereRange(battleMgr, center, radius, layerMask, exclusions, buffIdList)
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if cnt <= 0 then
    return nil
  end
  if table.IsNullOrEmpty(buffIdList) then
    return nil
  end
  local highest
  local highestBuffCount = 0
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local buffCountTotal = 0
      for _, buffId in pairs(buffIdList) do
        local buffCount = obj:GetBuffLevel(buffId)
        buffCountTotal = buffCountTotal + buffCount
      end
      if highest == nil or highestBuffCount < buffCountTotal then
        highestBuffCount = buffCountTotal
        highest = obj
      end
    end
  end
  return highest
end

local function CheckHasBossInSphereRange(battleMgr, center, radius, layerMask, exclusions, n)
  n = n or 1
  local cnt = PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask)
  if n > cnt then
    return false
  end
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and obj:GetCurBlood() > 0 and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() and obj.isBoss then
      n = n - 1
      if n == 0 then
        return obj
      end
    end
  end
  return false
end

local maskMap = {}
local TARGETING_MAP = {
  [BattleSearchType.Member] = {
    [PVECamp.Enemy] = {
      mask = LayerType.Zombie,
      searchType = BattleSearchType.Zombie
    },
    [PVECamp.Ally] = {
      mask = LayerType.Member,
      searchType = BattleSearchType.Member | BattleSearchType.ExcludeEnemyPet | BattleSearchType.AllTargetedPet
    },
    [PVECamp.Neutral] = {
      mask = LayerType.Junk,
      searchType = BattleSearchType.Junk
    },
    [PVECamp.Self] = {}
  },
  [BattleSearchType.Zombie] = {
    [PVECamp.Enemy] = {
      mask = LayerType.Member,
      searchType = BattleSearchType.Member | BattleSearchType.AllTargetedPet | BattleSearchType.OnlyEnemyPet
    },
    [PVECamp.Ally] = {
      mask = LayerType.Zombie,
      searchType = BattleSearchType.Zombie
    },
    [PVECamp.Neutral] = {
      mask = LayerType.Junk,
      searchType = BattleSearchType.Junk
    },
    [PVECamp.Self] = {}
  },
  [BattleSearchType.Junk] = {
    [PVECamp.Enemy] = {
      mask = LayerType.Zombie,
      searchType = BattleSearchType.Zombie
    },
    [PVECamp.Ally] = {
      mask = LayerType.Junk,
      searchType = BattleSearchType.Junk
    },
    [PVECamp.Neutral] = {
      mask = LayerType.Junk,
      searchType = BattleSearchType.Junk
    },
    [PVECamp.Self] = {}
  }
}
TARGETING_MAP[BattleSearchType.TacticalWeapon] = TARGETING_MAP[BattleSearchType.Member]
TARGETING_MAP[BattleSearchType.InvisiblePet] = TARGETING_MAP[BattleSearchType.Member]
TARGETING_MAP[BattleSearchType.OnlySelfPet] = TARGETING_MAP[BattleSearchType.Member]
TARGETING_MAP[BattleSearchType.ExcludeEnemyPet] = TARGETING_MAP[BattleSearchType.Member]
TARGETING_MAP[BattleSearchType.AllTargetedPet] = TARGETING_MAP[BattleSearchType.Member]
TARGETING_MAP[BattleSearchType.OnlyEnemyPet] = TARGETING_MAP[BattleSearchType.Member]
local targetLayerCache = {}

local function GetTargetLayer(mySearchType, targetTypeTable)
  local layerMask = 0
  local targetIncludeSelf = false
  local targetIncludeAlly = false
  local targetSearchType = 0
  if not TARGETING_MAP[mySearchType] then
    return layerMask, targetIncludeAlly, targetIncludeSelf, targetSearchType
  end
  
  local function AddSearchType(newType)
    targetSearchType = targetSearchType | newType
  end
  
  local function GetMaskType(layerType)
    if maskMap[layerType] then
      return maskMap[layerType]
    end
    local mask = LayerMask.GetMask(layerType)
    maskMap[layerType] = mask
    return mask
  end
  
  local function AddMask(layerType)
    layerMask = layerMask | GetMaskType(layerType)
  end
  
  local targetTypeTableLength = #targetTypeTable
  for i = 1, targetTypeTableLength do
    local v = targetTypeTable[i]
    if v == PVECamp.Ally then
      targetIncludeAlly = true
    elseif v == PVECamp.Self then
      targetIncludeSelf = true
    end
    local map = TARGETING_MAP[mySearchType][v]
    if map then
      if map.mask then
        AddMask(map.mask)
      end
      if map.searchType then
        AddSearchType(map.searchType)
      end
    end
  end
  local targetAllyExcludeSelf = targetIncludeAlly and not targetIncludeSelf
  local targetSelfExcludeAlly = not targetIncludeAlly and targetIncludeSelf
  return layerMask, targetAllyExcludeSelf, targetSelfExcludeAlly, targetSearchType
end

local function GetTargetLayerBin(mySearchType, targetTypeBin)
  local searchMap = targetLayerCache[mySearchType]
  if searchMap == nil then
    searchMap = {}
    targetLayerCache[mySearchType] = searchMap
  end
  local targetType = searchMap[targetTypeBin]
  if targetType == nil then
    targetType = {}
    searchMap[targetTypeBin] = targetType
  else
    return targetType.layerMask, targetType.targetAllyExcludeSelf, targetType.targetSelfExcludeAlly, targetType.targetSearchType
  end
  local layerMask = 0
  local targetIncludeSelf = false
  local targetIncludeAlly = false
  local targetSearchType = 0
  if not TARGETING_MAP[mySearchType] then
    return layerMask, targetIncludeAlly, targetIncludeSelf, targetSearchType
  end
  
  local function AddSearchType(newType)
    targetSearchType = targetSearchType | newType
  end
  
  local function GetMaskType(layerType)
    if maskMap[layerType] then
      return maskMap[layerType]
    end
    local mask = LayerMask.GetMask(layerType)
    maskMap[layerType] = mask
    return mask
  end
  
  local function AddMask(layerType)
    layerMask = layerMask | GetMaskType(layerType)
  end
  
  for i = 0, PVECamp.Count - 1 do
    local type = i
    if 0 < targetTypeBin & 1 << type + 1 then
      if type == PVECamp.Ally then
        targetIncludeAlly = true
      elseif type == PVECamp.Self then
        targetIncludeSelf = true
      end
      local map = TARGETING_MAP[mySearchType][type]
      if map then
        if map.mask then
          AddMask(map.mask)
        end
        if map.searchType then
          AddSearchType(map.searchType)
        end
      end
    end
  end
  local targetAllyExcludeSelf = targetIncludeAlly and not targetIncludeSelf
  local targetSelfExcludeAlly = not targetIncludeAlly and targetIncludeSelf
  targetType.layerMask = layerMask
  targetType.targetAllyExcludeSelf = targetAllyExcludeSelf
  targetType.targetSelfExcludeAlly = targetSelfExcludeAlly
  targetType.targetSearchType = targetSearchType
  return layerMask, targetAllyExcludeSelf, targetSelfExcludeAlly, targetSearchType
end

local function CheckCannonLookAt(unit, targetPos)
  local cannonTrans = unit.cannon
  local unitPos = unit:GetPosition()
  local targetDir = Vector3.Normalize(targetPos - unitPos)
  if targetDir:SqrMagnitude() < Epsilon then
    return true
  end
  local cannonForward
  if unit.localForward then
    cannonForward = cannonTrans:TransformDirection(unit.localForward)
  else
    cannonForward = cannonTrans.forward
  end
  cannonWorldForward.x, cannonWorldForward.z = cannonForward.x, cannonForward.z
  local cross = Vector3.Cross(cannonWorldForward, targetDir)
  local deg = math.abs(cross.y) * 60
  local maxDeg = unit.angular_speed_deg * Time.deltaTime
  if deg < maxDeg and Vector3.Dot(cannonWorldForward, targetDir) > 0 then
    if cross.y > 0 then
      cannonTrans:Rotate(UP, deg, WORLD)
    else
      cannonTrans:Rotate(UP, -deg, WORLD)
    end
    return true
  end
  if cross.y > 0 then
    cannonTrans:Rotate(UP, maxDeg, WORLD)
  else
    cannonTrans:Rotate(UP, -maxDeg, WORLD)
  end
  return false
end

local function SetLayerRecursively(gameObject, layerString)
  local transforms = gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Transform), true)
  local length = transforms.Length - 1
  for i = 0, length do
    if transforms[i].gameObject.layer ~= LayerMask.NameToLayer("PlaneShadowObject") and transforms[i].gameObject.layer ~= LayerMask.NameToLayer("OutLine") then
      transforms[i].gameObject.layer = LayerMask.NameToLayer(layerString)
    end
  end
end

local function TryEnterBattle(stageGroupId, stageId)
  DataCenter.ZombieBattleManager:Destroy()
  local param = {}
  param.type = PVEType.Barrage
  param.enterType = PVEEnterType.Default
  param.levelId = stageId
  param.levelGroupId = stageGroupId
  param.enterType = PVEEnterType.Default
  DataCenter.ZombieBattleManager:Enter(param)
end

local function GetPetInfo(targetdRule)
  local searchType, layer, showHpBar
  if targetdRule == BattlePetTargetedType.Invisible then
    searchType = BattleSearchType.InvisiblePet
    layer = "Junk"
    showHpBar = false
  elseif targetdRule == BattlePetTargetedType.OnlySelf then
    searchType = BattleSearchType.OnlySelfPet
    layer = "Junk"
    showHpBar = false
  elseif targetdRule == BattlePetTargetedType.ExcludeEnemy then
    searchType = BattleSearchType.ExcludeEnemyPet
    layer = "Member"
    showHpBar = true
  elseif targetdRule == BattlePetTargetedType.OnlyEnemy then
    searchType = BattleSearchType.OnlyEnemyPet
    layer = "Member"
    showHpBar = true
  else
    searchType = BattleSearchType.AllTargetedPet
    layer = "Member"
    showHpBar = true
  end
  return searchType, layer, showHpBar
end

local function DirectLookAtTarget(unit, targetPos)
  local trans = unit.transform
  if not trans then
    return true
  end
  local unitPos = unit:GetPosition()
  local targetDir = Vector3.Normalize(targetPos - unitPos)
  if targetDir:SqrMagnitude() < Epsilon then
    return true
  end
  trans.rotation = Quaternion.LookRotation(targetDir, Vector3.up)
  return true
end

local function FindRandomUnitInBoxRange(battleMgr, center, radius, nearestDis, farthestDis, layerMask, exclusions)
  local halfLength = (farthestDis - nearestDis) / 2
  local halfRadius = radius / 2
  local halfExtents = Vector3.New(halfRadius, halfRadius, halfLength)
  local cnt = PvePhysicsUtil.OverlapBoxNonAlloc(center, nearestDis + halfRadius, halfExtents, layerMask)
  halfExtents:ReturnPool()
  if cnt <= 0 then
    return false
  end
  local index = math.random(cnt)
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapBoxNonAllocResultObjId(index)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      return obj
    end
    index = index + 1
    if cnt < index then
      index = 1
    end
  end
  return false
end

local function FindNearestUnitInBoxRange(battleMgr, center, radius, nearestDis, farthestDis, layerMask, exclusions)
  local halfLength = (farthestDis - nearestDis) / 2
  local halfRadius = radius / 2
  local halfExtents = Vector3.New(halfRadius, halfRadius, halfLength)
  local cnt = PvePhysicsUtil.OverlapBoxNonAlloc(center, nearestDis + halfRadius, halfExtents, layerMask, true)
  halfExtents:ReturnPool()
  if cnt <= 0 then
    return nil
  end
  local minObjectId = PvePhysicsUtil.GetOverlapBoxNonAllocResultObjId(1)
  local minObj = battleMgr:GetUnit(minObjectId)
  if minObj ~= nil and 0 < minObj:GetCurBlood() and (not exclusions or not exclusions[minObj.guid]) and not minObj:IsUntargetable() then
    return minObj
  end
  local targetPos = center
  local nearest
  local minDist = 1000000
  for i = 1, cnt do
    local objectId = PvePhysicsUtil.GetOverlapBoxNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local dist = Vector3.ManhattanDistanceXZ(obj:GetPosition(), targetPos)
      if minDist > dist then
        minDist = dist
        nearest = obj
        if PvePhysicsUtil.useCollider2D ~= true then
          break
        end
      end
    end
  end
  return nearest
end

local function FindFarthestUnitInBoxRange(battleMgr, center, radius, nearestDis, farthestDis, layerMask, exclusions)
  local halfLength = (farthestDis - nearestDis) / 2
  local halfRadius = radius / 2
  local halfExtents = Vector3.New(halfRadius, halfRadius, halfLength)
  local cnt = PvePhysicsUtil.OverlapBoxNonAlloc(center, nearestDis + halfRadius, halfExtents, layerMask, true)
  halfExtents:ReturnPool()
  if cnt <= 0 then
    return nil
  end
  local maxObjectId = PvePhysicsUtil.GetOverlapBoxNonAllocResultObjId(cnt)
  local maxObj = battleMgr:GetUnit(maxObjectId)
  if maxObj ~= nil and 0 < maxObj:GetCurBlood() and (not exclusions or not exclusions[maxObj.guid]) and not maxObj:IsUntargetable() then
    return maxObj
  end
  local targetPos = center
  local farthest
  local maxDist = 0
  for i = cnt, 1, -1 do
    local objectId = PvePhysicsUtil.GetOverlapBoxNonAllocResultObjId(i)
    local obj = battleMgr:GetUnit(objectId)
    if obj ~= nil and 0 < obj:GetCurBlood() and (not exclusions or not exclusions[obj.guid]) and not obj:IsUntargetable() then
      local dist = Vector3.Distance(obj:GetPosition(), targetPos)
      if maxDist < dist then
        maxDist = dist
        farthest = obj
        if PvePhysicsUtil.useCollider2D ~= true then
          break
        end
      end
    end
  end
  return farthest
end

PveUtil.CheckConfigChanged = CheckConfigChanged
PveUtil.LoadHeroPowerCache = LoadHeroPowerCache
PveUtil.SaveHeroPowerCache = SaveHeroPowerCache
PveUtil.GetHeroPowerCache = GetHeroPowerCache
PveUtil.SetHeroPowerCache = SetHeroPowerCache
PveUtil.ClearHeroPowerCache = ClearHeroPowerCache
PveUtil.GetCacheKey = GetCacheKey
PveUtil.GetRecommendMonsterId = GetRecommendMonsterId
PveUtil.GetAverageHeroPower = GetAverageHeroPower
PveUtil.GetHeroPower = GetHeroPower
PveUtil.GetRecommendLevelLimitMonsterId = GetRecommendLevelLimitMonsterId
PveUtil.CheckHeroesBreak = CheckHeroesBreak
PveUtil.CheckHeroBreak = CheckHeroBreak
PveUtil.CheckHeroesMaxed = CheckHeroesMaxed
PveUtil.CheckHeroMaxed = CheckHeroMaxed
PveUtil.CheckHeroesRarity = CheckHeroesRarity
PveUtil.CheckHeroRarity = CheckHeroRarity
PveUtil.CheckHeroSlotEmpty = CheckHeroSlotEmpty
PveUtil.ParseArmyRecord = ParseArmyRecord
PveUtil.CanShowPowerLack = CanShowPowerLack
PveUtil.GetPowerLack = GetPowerLack
PveUtil.GetPowerLackTipClickFunc = GetPowerLackTipClickFunc
PveUtil.GetMaxSoldierNum = GetMaxSoldierNum
PveUtil.CalculateDamage = CalculateDamage
PveUtil.GetAllUnitsInSphereRange = GetAllUnitsInSphereRange
PveUtil.CheckHasUnitInSphereRange = CheckHasUnitInSphereRange
PveUtil.CheckHasBossInSphereRange = CheckHasBossInSphereRange
PveUtil.FindRandomUnitInSphereRange = FindRandomUnitInSphereRange
PveUtil.FindNearestUnitInSphereRange = FindNearestUnitInSphereRange
PveUtil.FindFarthestUnitInSphereRange = FindFarthestUnitInSphereRange
PveUtil.FindLowestHPUnitInSphereRange = FindLowestHPUnitInSphereRange
PveUtil.FindUnitInSectorRange = FindUnitInSectorRange
PveUtil.SetLayerRecursively = SetLayerRecursively
PveUtil.FindHighestMaxHPUnitInSphereRange = FindHighestMaxHPUnitInSphereRange
PveUtil.FindHighestPropertyUnitInSphereRange = FindHighestPropertyUnitInSphereRange
PveUtil.FindHighestBuffCountUnitInSphereRange = FindHighestBuffCountUnitInSphereRange
PveUtil.FindRandomUnitInBoxRange = FindRandomUnitInBoxRange
PveUtil.FindNearestUnitInBoxRange = FindNearestUnitInBoxRange
PveUtil.FindFarthestUnitInBoxRange = FindFarthestUnitInBoxRange
PveUtil.CheckCannonLookAt = CheckCannonLookAt
PveUtil.DirectLookAtTarget = DirectLookAtTarget
PveUtil.GetTargetLayer = GetTargetLayer
PveUtil.GetTargetLayerBin = GetTargetLayerBin
PveUtil.TryEnterBattle = TryEnterBattle
PveUtil.GetPetInfo = GetPetInfo
return ConstClass("PveUtil", PveUtil)
