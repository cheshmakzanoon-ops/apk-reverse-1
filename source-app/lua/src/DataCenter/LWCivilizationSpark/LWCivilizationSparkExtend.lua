local LWCivilizationSparkExtend = BaseClass("LWCivilizationSparkExtend")
local ArmedUpgradeGuideId = 8001

function LWCivilizationSparkExtend:__init()
  self.guideVersion = 1
  self.monopolyV0Interval = nil
  self.landV0Interval = nil
end

function LWCivilizationSparkExtend:__delete()
  self.guideVersion = nil
  self.monopolyV0Interval = nil
  self.landV0Interval = nil
end

function LWCivilizationSparkExtend:RefreshGuideVersion()
  if LuaEntry.Player:IsCivilizationSparkB() then
    self.guideVersion = 2
  else
    self.guideVersion = 1
  end
end

function LWCivilizationSparkExtend:UseCivilizationSparkGuide()
  return self.guideVersion == 2
end

function LWCivilizationSparkExtend:LWGuideUtil_onOpeningDebut(LWGuideUtil)
  if self.guideVersion == 2 then
    local t = {
      lwGuideRecord = GuideState.CityCopter
    }
    DataCenter.LWGuideManager:UpdateGuide(t)
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.CityCopter)
    DataCenter.LWOpeningStageManager.dirtyWorks.PlayTimeline(CiSparkTimelineType.EnterGame)
  else
    TimerManager:GetInstance():GetTimer(1, function()
      LWGuideUtil:OnOpeningDebut_2()
    end, self, true, true):Start()
  end
end

function LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStagePosArray(currStage)
  local utils = DataCenter.LWOpeningStageManager.utils
  if self.guideVersion == 2 then
    return utils.GetStageSoldierPosArr(currStage)
  else
    return utils.GetStagePosArr(currStage)
  end
end

function LWCivilizationSparkExtend:LWOpeningStageManager_requireDirtyWorks()
  if self.guideVersion == 2 then
    return require("DataCenter.LWCivilizationSpark.OpenStage.LWOpeningStageDirtyWorks_v2")
  else
    return require("DataCenter.LWOpeningStageManager.LWOpeningStageDirtyWorks")
  end
end

function LWCivilizationSparkExtend:LWOpeningStageManager_getMaxStageID()
  if self.guideVersion == 2 then
    return 4
  else
    return 7
  end
end

function LWCivilizationSparkExtend:LWOpeningStageManager_flagWinCameraMove(utils)
  if self.guideVersion == 2 then
    local currStage = DataCenter.LWOpeningStageManager.closeStages[1]
    if currStage.id == 3 then
      utils.FocusCameraToStageNode(3, 0)
    end
  end
end

function LWCivilizationSparkExtend:MainBuildingGuideCtrl_getMainFingerZ()
  if self.guideVersion == 2 then
    return 102
  else
    return 114.29
  end
end

function LWCivilizationSparkExtend:LWOpeningStageUtils_getOpenStagePrefabPath(default)
  if self.guideVersion == 2 then
    return "Assets/Main/Prefabs/LWCivilizationSpark/opening_stage_road_v2.prefab"
  else
    return default
  end
end

function LWCivilizationSparkExtend:LWOpeningStageUtils_bossTransLoaded(LWOpeningStageUtils, bossTrans, showBossTrans)
  if not IsNull(bossTrans) then
    if self.guideVersion == 2 then
      if showBossTrans then
        LWOpeningStageUtils.CivilizationSparkShowBoss()
      else
        LWOpeningStageUtils.CivilizationSparkHideBoss()
      end
    else
      local simpleAnim = bossTrans.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
      if not IsNull(simpleAnim) and DataCenter.LWOpeningStageManager.openStages[1].id == 2 then
        simpleAnim:Play("born")
        TimerManager:GetInstance():DelayInvoke(function()
          if not IsNull(simpleAnim) then
            simpleAnim:Play("idle")
          end
        end, 3)
      end
    end
  end
end

function LWCivilizationSparkExtend:LWOpeningStageEventDealer_getDirtyWorksdDoDelay()
  if self.guideVersion == 2 then
    return 0
  else
    return 0.2
  end
end

function LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStageSpeed(default)
  if self.guideVersion == 2 then
    return default * 1.3
  else
    return default
  end
end

function LWCivilizationSparkExtend:CityFakeRoadCtrl_getTheOneResPath(default)
  if self.guideVersion == 2 then
    return "Assets/Main/Prefabs/LWCivilizationSpark/opening_city_road_v2.prefab"
  else
    return default
  end
end

function LWCivilizationSparkExtend:FenceDisplayCtrl_getBadOneResPath()
  if self.guideVersion == 2 then
    return "Assets/Main/Prefabs/LWCivilizationSpark/A_build_posunweilan_v2.prefab"
  else
    return "Assets/_Art_LastWar/Models/Environment/Build/Posunweilan/prefab/A_build_posunweilan.prefab"
  end
end

function LWCivilizationSparkExtend:XiaoFanManager_onGateBuildingUpgradeDone(buildingData, ctrl)
  if self.guideVersion == 2 and buildingData.level == 1 then
    ctrl.Update()
  end
end

function LWCivilizationSparkExtend:FakeSoilder_getAmount(default)
  if self.guideVersion == 2 then
    return 8
  else
    return default
  end
end

function LWCivilizationSparkExtend:FakeSoilder_getSoliderZ()
  if self.guideVersion == 2 then
    return 88.5
  else
    return 95.5
  end
end

function LWCivilizationSparkExtend:FakeSoilder_getArmyPos(default)
  if self.guideVersion == 2 then
    local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARMY_YARD)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(build.itemId)
    if build then
      return BuildingUtils.GetBuildModelCenterVec(build.pointId, template.tileX, template.tileY) + Vector3.New(-4, 0, 4)
    end
    return default
  else
    return default
  end
end

function LWCivilizationSparkExtend:BuildingManager_getNewBuild(buildId, level)
  if self.guideVersion == 2 and buildId == BuildingTypes.LW_BUILD_ARMY_YARD and level == 1 then
    DataCenter.XiaoFanManager:SoliderRunToYard()
    local civilizationSparkData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_CIVILIZATION_SPARK)
    if civilizationSparkData then
      DataCenter.BuildBubbleManager:CheckShowBubble(civilizationSparkData.uuid)
    end
  end
end

function LWCivilizationSparkExtend:UILWArmedUpgradeBannerWarningView_moveEndGuideStart()
  if self.guideVersion == 2 and DataCenter.LWGuideFlowManager:ReadDone(ArmedUpgradeGuideId) then
    DataCenter.MonopolyManager:TryMoveCameraEnterCity()
  end
end

function LWCivilizationSparkExtend:UILWArmedUpgradeBannerWarningView_moveEndGuideEnd()
  if self.guideVersion == 2 then
    if not DataCenter.LWGuideFlowManager:ReadDone(ArmedUpgradeGuideId) then
      DataCenter.LWGuideFlowManager:TryTriggerFlexibly(ArmedUpgradeGuideId)
    end
  else
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_RADAR, true)
  end
end

function LWCivilizationSparkExtend:UILWArmedUpgradeMainView_tryOpenWarningNotIsFirstShow()
  if self.guideVersion == 2 then
    local data = DataCenter.MonopolyManager:GetCurData()
    if data ~= nil then
      GoToUtil.GotoCityPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.5, nil)
    end
  else
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_RADAR)
  end
end

function LWCivilizationSparkExtend:UILWArmedUpgradeMainView_needTryOpenWarning()
  if self.guideVersion == 2 then
    return true
  else
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_RADAR)
    return buildList == nil or table.count(buildList) == 0 or buildList[1] == nil
  end
end

function LWCivilizationSparkExtend:LWArmedUpgradeManager_getForceCloseArmedUpgradeMonopolyStageId()
  if self.guideVersion == 2 then
    return LuaEntry.DataConfig:TryGetNum("armed_upgrade_config", "k14")
  else
    return LuaEntry.DataConfig:TryGetNum("armed_upgrade_config", "k2")
  end
end

function LWCivilizationSparkExtend:LWArmedUpgradeCityDirectorBase_getCityActorHeroSpawnPos(actorData)
  if self.guideVersion == 2 then
    return {
      actorData[3][1] + 1,
      actorData[3][2]
    }
  else
    return actorData[2]
  end
end

function LWCivilizationSparkExtend:CityZoneFog_getPosOffset()
  if self.guideVersion == 2 then
    return Vector2.New(-1, 0)
  else
    return Vector2.New(-3, 2)
  end
end

function LWCivilizationSparkExtend:CityZoneFog_getFogInstXYZ()
  if self.guideVersion == 2 then
    return 0, 11, 0
  else
    return 0, 5, 0
  end
end

function LWCivilizationSparkExtend:CityZoneFog_getInitFogTile(defaultInitFogTile)
  if self.guideVersion == 2 then
    return {
      Vector2.New(0, -6),
      Vector2.New(0, 0),
      Vector2.New(0, -12),
      Vector2.New(-6, -18),
      Vector2.New(0, -18),
      Vector2.New(6, -18),
      Vector2.New(0, -24),
      Vector2.New(0, -30),
      Vector2.New(0, -36)
    }
  else
    return defaultInitFogTile
  end
end

function LWCivilizationSparkExtend:CityZoneFog_getInitFogTile2(defaultInitFogTile2)
  if self.guideVersion == 2 then
    return {
      Vector2.New(-13, -12),
      Vector2.New(-13, -20),
      Vector2.New(-13, -28),
      Vector2.New(-13, -36),
      Vector2.New(15, -18),
      Vector2.New(15, -28),
      Vector2.New(15, -36),
      Vector2.New(-7, -12),
      Vector2.New(-7, -20),
      Vector2.New(-7, -28),
      Vector2.New(-7, -36),
      Vector2.New(7, -18),
      Vector2.New(7, -28),
      Vector2.New(7, -36)
    }
  else
    return defaultInitFogTile2
  end
end

function LWCivilizationSparkExtend:CityZoneFog_getInitFogTileLittleBase()
  if self.guideVersion == 2 then
    return {
      Vector2.New(-6, -6),
      Vector2.New(-6, 0),
      Vector2.New(-6, 6),
      Vector2.New(0, 6),
      Vector2.New(6, 6),
      Vector2.New(6, 0),
      Vector2.New(6, -6),
      Vector2.New(15, -12),
      Vector2.New(7, -12)
    }
  else
    return {}
  end
end

function LWCivilizationSparkExtend:CityZoneMgr_createCityZone(param)
  if self.guideVersion == 2 then
    return require("DataCenter.LWCivilizationSpark.CityZone.CityZone_v2").New(param)
  else
    return require("Scene.CityZone.CityZone").New(param)
  end
end

function LWCivilizationSparkExtend:CityZoneMgr_getUnlockZoneIdList()
  local unlockZoneId = {}
  local index = 1
  for _, data in pairs(DataCenter.LandLockManager:GetAlllandLockData()) do
    if data.state == LandLockState.Finished then
      if self.guideVersion == 2 then
        if data.landToZone and data.landToZone ~= 0 then
          table.insert(unlockZoneId, data.landToZone)
        end
      else
        table.insert(unlockZoneId, index)
      end
      index = index + 1
    end
  end
  return unlockZoneId
end

function LWCivilizationSparkExtend:CityZoneMgr_getCityZoneMaxData(totalCount)
  local isZoneMax = true
  local path
  if self.guideVersion == 2 then
    local landCount = table.count(DataCenter.LandLockManager.landLockDataDict)
    landCount = landCount - 5
    for i, data in pairs(DataCenter.LandLockManager.landLockDataDict) do
      if data == nil or data.state ~= LandLockState.Finished or totalCount > landCount then
        isZoneMax = false
        path = "Assets/Main/Prefabs/LWCivilizationSpark/City_v2/Zone/CityZone.prefab"
        break
      end
    end
  else
    local landCount = table.count(DataCenter.LandLockManager.landLockDataDict)
    for _, data in ipairs(DataCenter.LandLockManager.landLockDataDict) do
      if data == nil or data.state ~= LandLockState.Finished or totalCount > landCount then
        isZoneMax = false
        path = "Assets/Main/Prefabs/City/Zone/CityZone.prefab"
        break
      end
    end
  end
  return isZoneMax, path
end

function LWCivilizationSparkExtend:MonopolyManager_getV0Interval()
  if self.monopolyV0Interval == nil then
    local cfg = LuaEntry.DataConfig:TryGetStr("city_land_unlock_v0", "k1")
    if not string.IsNullOrEmpty(cfg) then
      local split = string.split(cfg, ";")
      self.monopolyV0Interval = {}
      self.monopolyV0Interval[1] = tonumber(split[1])
      self.monopolyV0Interval[2] = tonumber(split[2])
    else
      self.monopolyV0Interval = {0, 0}
    end
  end
  return self.monopolyV0Interval
end

function LWCivilizationSparkExtend:MonopolyManager_inV0Interval(curId)
  local monopolyV0Interval = self:MonopolyManager_getV0Interval()
  if monopolyV0Interval and curId >= monopolyV0Interval[1] and curId <= monopolyV0Interval[2] then
    return true
  end
  return false
end

function LWCivilizationSparkExtend:MonopolyManager_getSkipUnlockIds(curId, skipId)
  local unlockIds = {}
  table.insert(unlockIds, curId)
  if skipId then
    if self.guideVersion == 2 then
      if self:MonopolyManager_inV0Interval(curId) then
        local monopolyV0Interval = self:MonopolyManager_getV0Interval()
        local min = math.min(skipId, monopolyV0Interval[2])
        for i = curId + 1, min do
          table.insert(unlockIds, i)
        end
        if 0 < skipId then
          for i = 1, skipId do
            table.insert(unlockIds, i)
          end
        end
      else
        if curId < 0 then
          self.LogError(string.format("%d\228\184\186\232\180\159\228\189\134\230\152\175\228\184\141\229\156\168city_land_unlock_v0\229\140\186\233\151\180\229\134\133", curId))
          curId = 0
        end
        for i = curId + 1, skipId do
          table.insert(unlockIds, i)
        end
      end
    else
      for i = curId + 1, skipId do
        table.insert(unlockIds, i)
      end
    end
  end
  return unlockIds
end

function LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
  local id = curId - 1
  if self.guideVersion == 2 then
    if curId == 1 then
      local monopolyV0Interval = self:MonopolyManager_getV0Interval()
      id = monopolyV0Interval[2]
    else
      id = curId - 1
    end
  else
    id = curId - 1
  end
  return id
end

function LWCivilizationSparkExtend:MonopolyManager_getNextId(curId)
  local id = curId + 1
  if self.guideVersion == 2 then
    local monopolyV0Interval = self:MonopolyManager_getV0Interval()
    if curId == monopolyV0Interval[2] then
      id = 1
    else
      id = curId + 1
    end
  else
    id = curId + 1
  end
  return id
end

function LWCivilizationSparkExtend:MonopolyManager_curIdIsOpen(curId)
  if self.guideVersion == 2 then
    return 0 < curId or self:MonopolyManager_inV0Interval(curId)
  else
    return 0 < curId
  end
end

function LWCivilizationSparkExtend:MonopolyManager_getCurFinishCount(curId)
  if self.guideVersion == 2 then
    local monopolyV0Interval = self:MonopolyManager_getV0Interval()
    if self:MonopolyManager_inV0Interval(curId) then
      return curId - monopolyV0Interval[1] + 1
    elseif 0 < curId then
      return curId + (monopolyV0Interval[2] - monopolyV0Interval[1] + 1)
    else
      return 0
    end
  else
    return curId
  end
end

function LWCivilizationSparkExtend:MonopolyManager_curGreaterCount(curId)
  local dataManager = DataCenter.MonopolyManager.dataManager
  if self.guideVersion == 2 then
    return self:MonopolyManager_getCurFinishCount(curId) > dataManager:GetPlacealityCount()
  else
    return curId > dataManager:GetPlacealityCount()
  end
end

function LWCivilizationSparkExtend:MonopolyManager_curGreaterEqualCount(curId)
  local dataManager = DataCenter.MonopolyManager.dataManager
  if self.guideVersion == 2 then
    return self:MonopolyManager_getCurFinishCount(curId) >= dataManager:GetPlacealityCount()
  else
    return curId >= dataManager:GetPlacealityCount()
  end
end

function LWCivilizationSparkExtend:MonopolyManager_getPlacealityData(curId, mapDic)
  local isEnd, data
  if self.guideVersion == 2 then
    if self:MonopolyManager_curGreaterEqualCount(curId) then
      isEnd = true
      data = mapDic[curId].obstacle.data
    elseif curId == DataCenter.MonopolyManager:GetV1LastMonopolyId() then
      isEnd = true
      data = mapDic[curId].obstacle.data
    else
      local nextId = self:MonopolyManager_getNextId(curId)
      if mapDic[nextId] == nil then
        Logger.LogError(string.format("\229\164\167\229\175\140\231\191\129\228\184\139\228\184\128\228\184\170\230\160\188\229\173\144%d\228\184\141\229\173\152\229\156\168", nextId))
      end
      data = mapDic[nextId].obstacle.data
    end
  else
    local dataManager = DataCenter.MonopolyManager.dataManager
    if curId >= dataManager:GetPlacealityCount() then
      isEnd = true
      data = mapDic[curId].obstacle.data
    elseif curId == DataCenter.MonopolyManager:GetV1LastMonopolyId() then
      isEnd = true
      data = mapDic[curId].obstacle.data
    else
      data = mapDic[curId + 1].obstacle.data
    end
  end
  return data, isEnd
end

function LWCivilizationSparkExtend:MonopolyManager_getInitPlacealityId()
  if self.guideVersion == 2 then
    local monopolyV0Interval = self:MonopolyManager_getV0Interval()
    return monopolyV0Interval[1]
  else
    return 1
  end
end

function LWCivilizationSparkExtend:MonopolyManager_getInitPlayerGuideId()
  if self.guideVersion == 2 then
    return 1001
  else
    return 1003
  end
end

function LWCivilizationSparkExtend:LandLockManager_getV0LandInternal()
  if self.landV0Interval == nil then
    local cfg = LuaEntry.DataConfig:TryGetStr("city_land_unlock_v0", "k2")
    if not string.IsNullOrEmpty(cfg) then
      local split = string.split(cfg, ";")
      self.landV0Interval = {}
      self.landV0Interval[1] = tonumber(split[1])
      self.landV0Interval[2] = tonumber(split[2])
      self.landV0Interval[3] = tonumber(split[3])
    end
  end
  return self.landV0Interval
end

function LWCivilizationSparkExtend:LandLockManager_inV0Interval(curId)
  local landV0Interval = self:LandLockManager_getV0LandInternal()
  if landV0Interval and curId >= landV0Interval[1] and curId <= landV0Interval[2] then
    return true
  end
  return false
end

function LWCivilizationSparkExtend:LandLockManager_getNextLandId(curId)
  if self.guideVersion == 2 then
    local landV0Interval = self:LandLockManager_getV0LandInternal()
    if landV0Interval and curId == landV0Interval[2] then
      local landData = DataCenter.LandLockManager:GetLandLockDataByCityZoneId(10)
      return landData.id
    else
      return curId + 1
    end
  else
    return curId + 1
  end
end

function LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(first, second)
  if self.guideVersion == 2 then
    local firstIn = self:LandLockManager_inV0Interval(first)
    local secondIn = self:LandLockManager_inV0Interval(second)
    if firstIn and not secondIn then
      local landV0Interval = self:LandLockManager_getV0LandInternal()
      local diff1 = first - landV0Interval[2]
      local diff2 = landV0Interval[3] - second
      return diff1 + diff2 - 1
    elseif not firstIn and secondIn then
      local landV0Interval = self:LandLockManager_getV0LandInternal()
      local diff1 = first - landV0Interval[3]
      local diff2 = landV0Interval[2] - second
      return diff1 + diff2 + 1
    else
      return first - second
    end
  else
    return first - second
  end
end

function LWCivilizationSparkExtend:MonopolyPlayer_getPlayerModelPath(Const)
  if self.guideVersion == 2 then
    return Const.PlayerModelPath_V2
  else
    return Const.PlayerMoedelPath
  end
end

function LWCivilizationSparkExtend:MonopolyCheerleader_resPath(default)
  if self.guideVersion == 2 then
    return "Assets/Main/Prefabs/LWCivilizationSpark/Monopoly/bubing11_AK_new_B.prefab"
  else
    return default
  end
end

function LWCivilizationSparkExtend:MonopolyPlayer_getSimpleList(transform)
  local simpleAnimList = {}
  if self.guideVersion == 2 then
    for i = 1, 4 do
      local trans = transform:Find(string.format("A_Hero_bubing05 (%d)/Hero@bubing05_skin (1)", i))
      if trans then
        local simpleAnim = trans.gameObject:GetComponent(typeof(CS.SimpleAnimation))
        if simpleAnim then
          table.insert(simpleAnimList, simpleAnim)
        end
      end
    end
  else
    local simpleAnim = transform:Find("A_Hero_bubing05/Hero@bubing05_skin (1)").gameObject:GetComponent(typeof(CS.SimpleAnimation))
    if simpleAnim then
      simpleAnimList[1] = simpleAnim
    end
  end
  return simpleAnimList
end

function LWCivilizationSparkExtend:HeroUnit_getBaseHpBarType(parkourType)
  if self.guideVersion == 2 then
    if parkourType == ParkourHeroUnitType.Soldier then
      return ParkourHpBarType.SoldierSmall
    else
      return ParkourHpBarType.Self
    end
  else
    return ParkourHpBarType.Self
  end
end

function LWCivilizationSparkExtend:FirstPayManager_getFirstPayLandId()
  if self.guideVersion == 2 then
    return LuaEntry.DataConfig:TryGetNum("civilization_spark_config", "k3")
  else
    return nil
  end
end

function LWCivilizationSparkExtend:BuildBubbleTip_getCanFreeRecruitHeroBubbleOffset()
  if self.guideVersion == 2 then
    return Vector3.New(0, 5, 0)
  else
    return nil
  end
end

function LWCivilizationSparkExtend:LWWelcomeBackManager_getTimelinePosZ()
  if self.guideVersion == 2 then
    return 91
  else
    return 100
  end
end

function LWCivilizationSparkExtend:LogError(str)
  Logger.LogError("LWCivilizationSparkExtend_" .. str)
end

return LWCivilizationSparkExtend
