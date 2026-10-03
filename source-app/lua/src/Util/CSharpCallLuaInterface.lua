local CSharpCallLuaInterface = {}
local CityPioneer_Const = require("Scene.CityPioneer.Const")
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local DataCenter = _ENV.DataCenter
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")

function CSharpCallLuaInterface.GetLuaStringTable()
  return {}
end

function CSharpCallLuaInterface.UpdateStrongholdBoss(uuid, curNum, maxNum)
  DataCenter.SeasonDataManager:UpdateMonsterDetail(uuid, {
    uuid = uuid,
    curNum = curNum,
    maxNum = maxNum
  })
end

function CSharpCallLuaInterface.UpdateViewRange(minX, minY, maxX, maxY)
  DataCenter.SceneCameraManager:UpdateWorldCameraView(minX, minY, maxX, maxY)
end

function CSharpCallLuaInterface.GetNeedPlayBornAnim()
  return DataCenter.AllianceSkillManager:GetNeedPlayBornAnim()
end

local _iconRenderConfig = {}
table.insert(_iconRenderConfig, {
  name = "HappyHouse",
  event = 600,
  order = 50,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyHouseInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyLevel",
  event = 600,
  order = 60,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyLvInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyPin",
  event = 600,
  order = 50,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyPinInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyShell",
  event = 600,
  order = 45,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyShellInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyAssistance",
  event = 1000,
  order = 1000,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyAssistanceInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyWolf",
  event = 1000,
  order = 50,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyWolfInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyTroopLinePoint",
  event = 450,
  order = 50,
  minLod = 1,
  maxLod = 2,
  matPath = "Assets/Main/Material/HappyTroopLinePointInstancing.mat",
  gizmosColor = Color.New(1, 1, 0, 0.0)
})
table.insert(_iconRenderConfig, {
  name = "HappyTroopCircle",
  event = 500,
  order = 10,
  minLod = 1,
  maxLod = 2,
  matPath = "Assets/Main/Material/HappyTroopCircleInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyWorldResIcon",
  event = 600,
  order = 50,
  minLod = 3,
  maxLod = 5,
  matPath = "Assets/Main/Material/HappyWorldResInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyWorldResLv",
  event = 600,
  order = 60,
  minLod = 1,
  maxLod = 7,
  matPath = "Assets/Main/Material/HappyWorldResLvInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyWorldMonsterIcon",
  event = 600,
  order = 60,
  minLod = 3,
  maxLod = 4,
  matPath = "Assets/Main/Material/HappyWorldMonsterInstancing.mat"
})
table.insert(_iconRenderConfig, {
  name = "HappyWorldMonsterLv",
  event = 600,
  order = 61,
  minLod = 3,
  maxLod = 3,
  matPath = "Assets/Main/Material/HappyWorldMonsterLvInstancing.mat"
})

function CSharpCallLuaInterface.GetWorldIconRenderConfig()
  return _iconRenderConfig
end

function CSharpCallLuaInterface.HasMonsterRebornAni(uuid)
  local theDetail = DataCenter.SeasonDataManager:GetMonsterDetail(uuid)
  if theDetail and theDetail.reborn then
    return true
  end
  return false
end

function CSharpCallLuaInterface.GetString(param)
  if param == "TableNameOfWorldCity" then
    return TableName.WorldCity
  end
  return ""
end

function CSharpCallLuaInterface.GetInt(param)
  if param == "AllianceStoveCenterPos" then
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.Build or theStoveCenter.status == AllianceMineStatus.Ruin or theStoveCenter.status == AllianceMineStatus.FoldUp then
      return 0
    end
    return theStoveCenter.pointId
  elseif param == "ActDispatchTaskTodayStealNum" then
    return DataCenter.ActDispatchTaskDataManager:GetTodayStealNum()
  elseif param == "Season4BrightnessLevel" then
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus ~= nil and lightHouseStatus.active then
      return toInt(lightHouseStatus.brightnessLevel)
    end
  elseif param == "ActDispatchTaskTodayAssistNum" then
    return DataCenter.ActDispatchTaskDataManager:GetTodayAssistNum()
  elseif param == "ActDispatchTaskMaxStealNum" then
    return DataCenter.ActDispatchTaskDataManager:GetDispatchSetting("steal_count")
  elseif param == "ActDispatchTaskMaxAssistNum" then
    return DataCenter.ActDispatchTaskDataManager:GetDispatchSetting("aid_count")
  elseif param == "SeasonIndex" then
    return DataCenter.SeasonDataManager:GetSeason() or 0
  elseif param == "SeasonId" then
    return DataCenter.SeasonDataManager:GetSeasonId() or 0
  elseif param and string.startswith(param, "CheckSeasonBuild,") then
    local data = string.split(param, ",")
    if data and SeasonUtil.IsSeasonPlayerBuilding(toInt(data[2])) then
      return 1
    end
  elseif param == "NewPlayerInfo" then
    if UIUtil.UseNewPlayerInfo() then
      return 1
    end
  elseif param == "ActGhostreconTodayStealNum" then
    return DataCenter.ActGhostreconManager.stealTimes
  elseif param == "ActGhostreconTodayTeamWorkNum" then
    return DataCenter.ActGhostreconManager.teamworkRewardTimes
  elseif param == "ActGhostreconMaxStealNum" then
    local cfg = DataCenter.ActGhostreconManager:GetNowSettingCfg()
    return cfg and cfg.stealCount or 0
  elseif param == "ActGhostreconMaxTeamWorkNum" then
    local cfg = DataCenter.ActGhostreconManager:GetNowSettingCfg()
    return cfg and cfg.teamworkCount or 0
  elseif param == "SEASON_MUMMY_CURSE1" then
    return EffectDefine.SEASON_MUMMY_Status_Id_CURSE1
  elseif param == "SEASON_MUMMY_CURSE2" then
    return EffectDefine.SEASON_MUMMY_Status_Id_CURSE2
  elseif param == "SEASON_MUMMY_CURSE3" then
    return EffectDefine.SEASON_MUMMY_Status_Id_CURSE3
  elseif param and string.startswith(param, "CityAttachmentSlotId,") then
    local data = string.split(param, ",")
    local pointId = toInt(data[2])
    local serverId = toInt(data[3])
    local cityId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if cityMeta and cityMeta.pos and cityMeta.pos.y and cityMeta.pos.x then
      local buildPos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      if buildPos.y > cityMeta.pos.y then
        return 2
      end
      if buildPos.x > cityMeta.pos.x and buildPos.y < cityMeta.pos.y then
        return 1
      end
      if buildPos.x < cityMeta.pos.x and buildPos.y < cityMeta.pos.y then
        return 0
      end
    end
    local cfg = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(cityId)
    if cfg then
      local slotId = toInt(cfg:GetSlotIdByBuildPos(pointId))
      if 0 < slotId then
        return slotId - 1
      end
    end
  end
  return 0
end

function CSharpCallLuaInterface.ToggleCityCheat()
  CityTriggerPointManager:GetInstance():ToggleCheat()
  DataCenter.BattleLevel:ToggleCheat()
end

function CSharpCallLuaInterface.GetDataTableCount(xmlName)
  return LocalController:instance():GetTableLength(xmlName)
end

function CSharpCallLuaInterface.GetTemplateData(_type, itemId, name)
  if LuaEntry.Player ~= nil then
    _type = LuaEntry.Player:GetABTestTableName(_type)
  end
  return LocalController:instance():getStrValue(_type, itemId, name)
end

function CSharpCallLuaInterface.GetHeadFrame(headSkinId, headSkinET)
  return DataCenter.DecorationDataManager:GetHeadFrame(headSkinId, headSkinET) or DefaultHeadFramePath
end

function CSharpCallLuaInterface.GetAllMultiKillConfig()
end

function CSharpCallLuaInterface.GetAllMultiKillPinConfig()
  local pinTime = {}
  LocalController:instance():visitTable(TableName.WorldMultiKill, function(id, lineData)
    pinTime[lineData:getIntValue("start")] = lineData:getIntValue("top_streak_hold_sec", 10) or 10
  end)
  return pinTime
end

function CSharpCallLuaInterface.GetWorldPointTileSize(pointId)
  return WorldBuildUtil.GetBuildTile(pointId)
end

function CSharpCallLuaInterface.GetAllianceColorList()
  return DataCenter.WorldAllianceCityDataManager:GetAllianceColorList()
end

function CSharpCallLuaInterface.GetAllianceCityList()
  return DataCenter.WorldAllianceCityDataManager:GetAllianceCityList()
end

function CSharpCallLuaInterface.GetAllianceCitySimpleDataByPointInfo(pointInfo)
  return WorldBuildUtil.GetAllianceCitySimpleDataByPointInfo(pointInfo)
end

function CSharpCallLuaInterface:GetOasisViewScaleList()
  return DataCenter.SeasonDataManager:GetOasisViewScaleList()
end

function CSharpCallLuaInterface.GetWorldPointModelPath(pointInfo)
  return WorldBuildUtil.GetWorldPointModelPath(pointInfo)
end

function CSharpCallLuaInterface.GetRetreatModelPath(cityId)
  local template = DataCenter.AllianceCityTemplateManager:GetCurServerConfig(cityId)
  if template then
    local ret = template.monster_treat_prefab
    if string.IsNullOrEmpty(ret) then
      return nil
    end
    return ret
  end
  return nil
end

function CSharpCallLuaInterface.GetAllianceCityIdByPointInfo(pointInfo)
  return WorldBuildUtil.GetAllianceCityIdByPointInfo(pointInfo)
end

function CSharpCallLuaInterface.GetBoardData(uuid)
  return DataCenter.BoardManager:GetBoardData(uuid)
end

function CSharpCallLuaInterface.GetBoardDataByPointId(pointId)
  return DataCenter.BoardManager:GetBoardDataByPointId(pointId)
end

function CSharpCallLuaInterface.IsTruckRoad(pointId)
  local bd = CSharpCallLuaInterface.GetBoardDataByPointId(pointId)
  if bd ~= nil then
    return true
  end
  return false
end

function CSharpCallLuaInterface.IsRoad(pointId)
  local bd = CSharpCallLuaInterface.GetBoardDataByPointId(pointId)
  if bd ~= nil then
    return true
  end
  return false
end

function CSharpCallLuaInterface.GetBuildMaxRadius()
  return DataCenter.BoardManager:GetBuildMaxRadius()
end

function CSharpCallLuaInterface.GetOtherLimitRadius()
  return DataCenter.BoardManager:GetOtherLimitRadius()
end

function CSharpCallLuaInterface.GetRoadBuildTime()
  return DataCenter.BoardManager:GetBuildTime() / 1000
end

function CSharpCallLuaInterface.GetAllRoadData()
  return DataCenter.BoardManager:GetAllRoadData()
end

function CSharpCallLuaInterface.GetAllShowRoadData()
  return DataCenter.BoardManager:GetAllShowRoadData()
end

function CSharpCallLuaInterface.InitRoadData(message)
  DataCenter.BoardManager:InitData(message)
end

function CSharpCallLuaInterface.ResetBoard()
  return DataCenter.BoardManager:ResetBoard()
end

function CSharpCallLuaInterface.CheckSwitch(key)
  return LuaEntry.DataConfig:CheckSwitch(key)
end

function CSharpCallLuaInterface.CheckSwitchSafe(key)
  local switchState = LuaEntry.DataConfig:CheckSwitchSafe(key)
  if switchState == nil then
    return -1
  else
    return switchState == true and 1 or 0
  end
end

function CSharpCallLuaInterface.GetIsAllianceCityOpen()
  return true
end

function CSharpCallLuaInterface.GetConfigNum(key1, key2, default)
  if LuaEntry == nil then
    return default or 0
  end
  return LuaEntry.DataConfig:TryGetNum(key1, key2, default)
end

function CSharpCallLuaInterface.GetConfigStr(key1, key2, default)
  return LuaEntry.DataConfig:TryGetStr(key1, key2, default)
end

function CSharpCallLuaInterface.GetTrainingTypeAndBuildingType(buildId)
  return BuildingUtils.GetTrainingTypeAndBuildingType(buildId)
end

function CSharpCallLuaInterface.GetMainPos()
  local pos = BuildingUtils.GetMainPos()
  return CS.UnityEngine.Vector2Int(pos.x, pos.y)
end

function CSharpCallLuaInterface.SetMainPos()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
    EventManager:GetInstance():Broadcast(EventId.MainPosChanged)
  end
end

function CSharpCallLuaInterface.GetBuildTileIndex(buildId, index)
  return BuildingUtils.GetBuildTileIndex(buildId, index)
end

function CSharpCallLuaInterface.IsCanPutDownByBuild(buildId, index, buildUuid, noPutPoint, theServerId)
  return BuildingUtils.IsCanPutDownByBuild(buildId, index, buildUuid, noPutPoint, theServerId)
end

function CSharpCallLuaInterface.IsCanShowCollectGreenByPoint(index)
  return BuildingUtils.IsCanShowCollectGreenByPoint(index)
end

function CSharpCallLuaInterface.GetOutermostIndexByIndex(index, radius, maxX, maxY)
  return BuildingUtils.GetOutermostIndexByIndex(index, radius, maxX, maxY)
end

function CSharpCallLuaInterface.GetBuildModelCenter(mainIndex, tileX, tileY)
  return BuildingUtils.GetBuildModelCenter(mainIndex, tileX, tileY)
end

function CSharpCallLuaInterface.GetBuildModelCenterVec(mainIndex, tileX, tileY)
  return BuildingUtils.GetBuildModelCenterVec(mainIndex, tileX, tileY)
end

function CSharpCallLuaInterface.GetCollectMaxEffectByBuildId(buildId)
  return DataCenter.BuildManager:GetCollectMaxEffectByBuildId(buildId)
end

function CSharpCallLuaInterface.GetDirByPos(lastPos, curPos, nextPos)
  local openDir, flowDir = CommonUtil.GetDirByPos(lastPos, curPos, nextPos)
  return openDir
end

function CSharpCallLuaInterface.SendFindMainBuildInitPositionMessage()
  SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
end

function CSharpCallLuaInterface.GetMainLv()
  return DataCenter.BuildManager.MainLv
end

function CSharpCallLuaInterface.CheckReplaceMain()
  DataCenter.BuildManager:CheckReplaceMain()
end

function CSharpCallLuaInterface.UpdateBuildings(message)
  DataCenter.BuildManager:UpdateBuildings(message.building_new)
end

function CSharpCallLuaInterface.GetAllLuaBuildWithoutFoldUp(list)
  local buildList = DataCenter.BuildManager:GetAllBuildWithoutPickUp()
  if buildList ~= nil then
    for k, v in ipairs(buildList) do
      if not v.isWorldBuild then
        list:Add(CS.LuaBuildData(v.uuid, v.updateTime, v.pointId, v.state, v.itemId, v.level))
      end
    end
  end
  return list
end

function CSharpCallLuaInterface.TryGetAllLuaBuildWithoutFoldUp()
  local luaArray = SceneUtils.GetSceneLuaArray()
  if luaArray == nil then
    return false
  end
  local count = 0
  luaArray[1] = 0
  local allBuilding = DataCenter.BuildManager:GetAllBuildData()
  if allBuilding ~= nil then
    for _, v in pairs(allBuilding) do
      if v.state ~= BuildingStateType.FoldUp and not v.isWorldBuild then
        luaArray[1 + count * 6 + 1] = v.uuid
        luaArray[1 + count * 6 + 2] = v.updateTime
        luaArray[1 + count * 6 + 3] = v.pointId
        luaArray[1 + count * 6 + 4] = v.state
        luaArray[1 + count * 6 + 5] = v.itemId
        luaArray[1 + count * 6 + 6] = v.level
        count = count + 1
        if v.itemId ~= BuildingTypes.FUN_BUILD_MAIN and SceneUtils.CheckNeedSyncCityBuildIdName(v.itemId, v.level) then
          local name = BuildingUtils.GetCityBuildingModelName(v.itemId, v.level)
          SceneUtils.SyncCityBuildIdName(name, v.itemId, v.level)
        end
      end
    end
  end
  luaArray[1] = count
  return true
end

function CSharpCallLuaInterface.GetBuildingDataByUuid(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    return CS.LuaBuildData(buildData.uuid, buildData.updateTime, buildData.pointId, buildData.state, buildData.itemId, buildData.level)
  end
end

function CSharpCallLuaInterface.GetBuildingDataParamByUuid(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    return buildData.uuid, buildData.updateTime, buildData.pointId, buildData.state, buildData.itemId, buildData.level
  end
end

function CSharpCallLuaInterface.GetBuildingDataByBuildId(buildId)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  if buildData ~= nil then
    return CS.LuaBuildData(buildData.uuid, buildData.updateTime, buildData.pointId, buildData.state, buildData.itemId, buildData.level)
  end
end

function CSharpCallLuaInterface.GetBuildingDataParamByBuildId(buildId)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  if buildData ~= nil then
    return buildData.uuid, buildData.updateTime, buildData.pointId, buildData.state, buildData.itemId, buildData.level
  end
end

function CSharpCallLuaInterface.GetAllInBaseTruckShowBuild(list)
  local buildList = DataCenter.BuildManager:GetAllInBaseTruckShowBuild()
  if buildList ~= nil then
    for k, v in ipairs(buildList) do
      list:Add(CS.LuaBuildData(v.uuid, v.updateTime, v.pointId, v.state, v.itemId, v.level))
    end
  end
  return list
end

function CSharpCallLuaInterface.IsInNewUserWorld()
  return DataCenter.BuildManager:IsInNewUserWorld()
end

function CSharpCallLuaInterface.GetBuildDataResourcePercent(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    return buildData:GetResourcePercent()
  end
  return 0
end

function CSharpCallLuaInterface.CheckTreasureReachDailyLimit(cfgId)
  return DataCenter.ActDetectTreasureDataManager:CheckTreasureReachDailyLimit(cfgId)
end

function CSharpCallLuaInterface.GetBuildStartTimeAndEndTime(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local result = {}
    result.startTime = buildData.startTime
    result.endTime = buildData.updateTime
    return result
  end
end

function CSharpCallLuaInterface.IsBuildWork(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    return buildData.unavailableTime == 0 and now < buildData.produceEndTime
  end
  return false
end

function CSharpCallLuaInterface.GetBuildQueueState(uuid)
  return DataCenter.BuildManager:GetBuildQueueState(uuid)
end

function CSharpCallLuaInterface.GetCityFurnaceState()
  local state = DataCenter.BuildManager:GetFurnaceStateAndTemp()
  return state
end

function CSharpCallLuaInterface.InitCityPointData(message)
  DataCenter.CityPointDataManager:InitData(message)
end

function CSharpCallLuaInterface.GetAllCityPointData()
  return DataCenter.CityPointDataManager:GetAllPointData()
end

function CSharpCallLuaInterface.GetCityPointDataByPointId(pointId)
  return DataCenter.CityPointDataManager:GetPointDataByPointId(pointId)
end

function CSharpCallLuaInterface.GetPointDataByUuid(uuid)
  return DataCenter.CityPointDataManager:GetPointDataByUuid(uuid)
end

function CSharpCallLuaInterface.GetResTypeIconPathByType(type)
  return CityPioneer_Const.ResTypeIconPath[type] or ""
end

function CSharpCallLuaInterface.GetSingleMapJunkTemplate(itemId)
  return DataCenter.SingleMapJunkTemplateManager:GetTemplate(itemId)
end

function CSharpCallLuaInterface.RemoveCityPointDataByPointId(pointId)
  DataCenter.CityPointDataManager:RemovePointDataByPointId(pointId)
end

function CSharpCallLuaInterface.RemoveCityPointDataByUuid(uuid)
  DataCenter.CityPointDataManager:RemovePointDataByUuid(uuid)
end

function CSharpCallLuaInterface.GetCityPointType(pointId)
  return DataCenter.CityPointManager:GetPointType(pointId)
end

function CSharpCallLuaInterface.GetCityPointSize(pointId)
  return DataCenter.CityPointManager:GetPointSize(pointId)
end

function CSharpCallLuaInterface.GetResourceNameByType(resourceType)
  return CommonUtil.GetResourceNameByType(resourceType)
end

function CSharpCallLuaInterface.SetIsInCity(value)
  SceneUtils.SetIsInCity(value)
end

function CSharpCallLuaInterface.CheckIsInBuildRange(Ax, Ay, Bx, By, tileX, tileY)
  return BuildingUtils.CheckIsInBuildRange(Ax, Ay, Bx, By, tileX, tileY)
end

function CSharpCallLuaInterface.IsCollectRangePoint(pointIndex)
  return WorldBuildUtil.IsCollectRangePoint(pointIndex)
end

function CSharpCallLuaInterface.GetCollectRangePoint(pointIndex, resourceType)
  return WorldBuildUtil.GetCollectRangePoint(pointIndex, resourceType)
end

function CSharpCallLuaInterface.OnPointDownMarch(marchUuid)
  UIUtil.OnPointDownMarch(marchUuid)
end

function CSharpCallLuaInterface.OnPointUpMarch(marchUuid)
  UIUtil.OnPointUpMarch(marchUuid)
end

function CSharpCallLuaInterface.OnBeginDragMarch(marchUuid)
  UIUtil.OnMarchDragStart(marchUuid)
end

function CSharpCallLuaInterface.GetResourcePercent(buildId, buildLv, endTime, startTime)
  return BuildingUtils.GetResourcePercent(buildId, buildLv, endTime, startTime)
end

function CSharpCallLuaInterface.GetBuildCollectSpeed(buildId, level)
  local max = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  if buildLevelTemplate ~= nil then
    max = buildLevelTemplate:GetCollectSpeed()
  end
  return max
end

function CSharpCallLuaInterface.GetBuildCollectMaxSelf(buildId, level)
  local max = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  if buildLevelTemplate ~= nil then
    max = buildLevelTemplate:GetCollectMax()
  end
  return max
end

function CSharpCallLuaInterface.GetBuildCollectMaxOther(buildId, level)
  local max = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  if buildLevelTemplate ~= nil then
    max = buildLevelTemplate:GetCollectMaxOthers()
  end
  return max
end

function CSharpCallLuaInterface.GetShowBubblePercent(buildId, level)
  local percent = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  if buildLevelTemplate ~= nil then
    percent = buildLevelTemplate:GetShowBubblePercent()
  end
  return percent
end

function CSharpCallLuaInterface.GetNextChangeTimeByResourceUuid(uuid, percent)
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data ~= nil then
    return data:GetNextChangeTimeByPercent(percent)
  end
  return 0
end

function CSharpCallLuaInterface.GetNeedRefreshWorldPointSize()
  return false
end

function CSharpCallLuaInterface.GetAllBuildTileByItemId()
  return DataCenter.BuildTemplateManager:GetAllBuildTileByItemId()
end

function CSharpCallLuaInterface.GetAllyCitySize()
  if DataCenter.LandlordMgr:IsInNewCenterMapPeriod() then
    return DataCenter.AllianceCityTemplateManager:GetAllyCitySize(LuaEntry.Player:GetSourceServerId())
  else
    return DataCenter.AllianceCityTemplateManager:GetAllyCitySize(LuaEntry.Player:GetCurServerId())
  end
end

function CSharpCallLuaInterface.GetAllTreasureSize()
  return DataCenter.TreasureTemplateManager:GetAllTreasureSize()
end

function CSharpCallLuaInterface.GetAllWorldTriggerConfig()
  return DataCenter.WorldTriggerTemplateManager:GetAllMeta()
end

function CSharpCallLuaInterface.GetAllTrainConfig()
  return DataCenter.LWTrainDataManager:GetAllMeta()
end

function CSharpCallLuaInterface.GetFlowerCarLength()
  return FlowerCarLength
end

function CSharpCallLuaInterface.GetAllBuildOffset()
  return DataCenter.BuildTemplateManager:GetAllBuildOffset()
end

function CSharpCallLuaInterface.GetLodArray()
  return LodArray
end

function CSharpCallLuaInterface.GetCityLodArray()
  return CityLodArray
end

function CSharpCallLuaInterface.IsCanShowBuildBtn()
  return BuildingUtils.CanMoveBuild()
end

function CSharpCallLuaInterface.CanMoveBuild(buildId)
  return BuildingUtils.CanMoveBuild(buildId)
end

function CSharpCallLuaInterface.CheckIsInBasementRange(pointId)
  return WorldBuildUtil.CheckIsInBasementRange(pointId)
end

function CSharpCallLuaInterface.GetConfigMd5()
  return LuaEntry.DataConfig:GetMd5()
end

function CSharpCallLuaInterface.IsShowBuildFlyPath()
  return DataCenter.BuildManager:IsShowBuildFlyPath()
end

function CSharpCallLuaInterface.SetGuideGarbageCollectTime(startTime, endTime)
  DataCenter.PickGarbageDataManager:SetTime(startTime, endTime)
end

function CSharpCallLuaInterface.AddGuideGarbageCollectToQueue(pointId)
  DataCenter.PickGarbageDataManager:AddIndexToGarbageQueue(pointId)
end

function CSharpCallLuaInterface.RemoveFromGarbageQueue(pointId)
  DataCenter.PickGarbageDataManager:RemoveFromGarbageQueue(pointId)
end

function CSharpCallLuaInterface.GetCurrentGarbageQueue()
  return DataCenter.PickGarbageDataManager:GetCurrentPickIndex()
end

function CSharpCallLuaInterface.GetAllianceLeaderUid()
  local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  return allianceBaseData and allianceBaseData.leaderUid or ""
end

function CSharpCallLuaInterface.IsShowPrologue()
  local flag = DataCenter.GuideManager:IsShowPrologue()
  return flag
end

function CSharpCallLuaInterface.IsBeforePrologue()
  return DataCenter.CityPioneerManager:IsBeforePrologue()
end

function CSharpCallLuaInterface.NewLuaObj(pointId, modelObjectType)
  local CityGarbageBase = require("Scene.CityPioneer.CityGarbage.CityGarbageBase")
  local ret = CityGarbageBase.New(pointId, modelObjectType)
  return ret
end

function CSharpCallLuaInterface.OnLoadSceneOK(sceneNode, sceneName)
  local list = {}
  local garbageRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Interactive")
  if garbageRoot then
    if not CSharpCallLuaInterface.CanShowLandLock() then
      local nodeNames = {
        "rock",
        "crystal",
        "cactus",
        "water",
        "wood"
      }
      for _, nodeName in pairs(nodeNames) do
        local nodeRoot = garbageRoot:Find(nodeName)
        if nodeRoot ~= nil then
          local childCount = nodeRoot.childCount
          for i = 0, childCount - 1 do
            local child = nodeRoot:GetChild(i).gameObject
            local instanceId = child:GetInstanceID()
            local build = CS.SceneManager.World:AddObjectByPointId(instanceId, 20)
            build._luaTable:BindGameObject(instanceId, child)
          end
        end
      end
    end
    table.insert(list, garbageRoot)
  end
  local mountainRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Mountain")
  if mountainRoot then
    table.insert(list, mountainRoot)
  end
  local plantRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Plant")
  if plantRoot then
    table.insert(list, plantRoot)
  end
  local groundRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Ground")
  if groundRoot then
    table.insert(list, groundRoot)
  end
  DataCenter.GuideCityManager:SetCityRoot(list)
end

function CSharpCallLuaInterface.OnUploadPicStart()
  LuaEntry.Player:UploadPicStart()
end

function CSharpCallLuaInterface.GetPlayerPic()
  return LuaEntry.Player:GetPic()
end

function CSharpCallLuaInterface.GetPlayerPicVer()
  return LuaEntry.Player:GetPicVer()
end

function CSharpCallLuaInterface.GetHeroQuality(rarity, reachMax)
  local isReachMax = reachMax
  if isReachMax ~= nil and isReachMax == true then
    if rarity ~= HeroUtils.RarityType.S then
      isReachMax = false
    end
  else
    isReachMax = false
  end
  return HeroUtils.GetCircleQualityIconPath(rarity, isReachMax)
end

function CSharpCallLuaInterface.GetHeroIcon(heroId, skinId)
  return HeroUtils.GetHeroIconRoundPath(heroId, skinId)
end

function CSharpCallLuaInterface.GetMarchStateIcon(marchInfo)
  return MarchUtil.GetMarchStateIconByType(marchInfo)
end

function CSharpCallLuaInterface.GetLandLockDataById(id)
  return DataCenter.LandLockManager:GetLandLockDataById(id)
end

function CSharpCallLuaInterface.GetLandLockDataByPointId(id)
  return DataCenter.LandLockManager:GetLandLockDataByPointId(id)
end

function CSharpCallLuaInterface.GetLandLockDataListByState(state)
  return DataCenter.LandLockManager:GetLandLockDataListByState(state)
end

function CSharpCallLuaInterface.CanShowLandLock()
  return true
end

function CSharpCallLuaInterface.ClickLandLockById(id)
  return DataCenter.LandLockManager:ClickLandLockById(id)
end

function CSharpCallLuaInterface.ClickSelfLandLock(id)
end

function CSharpCallLuaInterface.ClickOtherLandLockById(id, pointId)
end

function CSharpCallLuaInterface.LandLockTimeLineFinish(id, alter)
  DataCenter.LandLockManager:OnLandLockTimeLineFinish(id, alter)
end

function CSharpCallLuaInterface.GetMonsterLockDataList(state)
  return DataCenter.MonsterLockDataManager:GetAllMonsterExceptRewardData()
end

function CSharpCallLuaInterface.ClickMonsterLockById(id)
  return DataCenter.MonsterLockDataManager:ClickMonsterLockById(id)
end

function CSharpCallLuaInterface.GetBuffPerformanceInfo(buffId)
  return DataCenter.StatusManager:GetBuffPerformanceInfo(buffId)
end

function CSharpCallLuaInterface.CanShowCityLabel()
  return DataCenter.BuildManager.showCityLabel == true
end

function CSharpCallLuaInterface.IsShowWorldCollectPoint()
  return DataCenter.GuideManager:IsShowWorldCollectPoint()
end

function CSharpCallLuaInterface.SendErrorMessageToServer(errorMsg)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  CommonUtil.SendErrorMessageToServer(now, now, errorMsg)
end

function CSharpCallLuaInterface.GetAllProxy()
  return CommonUtil.GetAllProxy()
end

function CSharpCallLuaInterface.GetFightAllianceId()
  if DataCenter.AllianceCompeteDataManager:IsBattleDay() then
    return DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
  end
  return ""
end

function CSharpCallLuaInterface.GetWorldMainPos()
  return LuaEntry.Player:GetMainWorldPos()
end

function CSharpCallLuaInterface.GetDragonWorldPos()
  return LuaEntry.Player:GetBattleFieldPos()
end

function CSharpCallLuaInterface.GetMainUuid()
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild then
    return mainBuild.uuid
  end
  return 0
end

function CSharpCallLuaInterface.CurWorldIsSnowSeason()
  return SeasonUtil.IsCurWorldInSeasonSnowModeWithoutGroup()
end

function CSharpCallLuaInterface.HandleThermalConductorTemperature(temp)
  EventManager:GetInstance():Broadcast(EventId.ThermalConductorTemperature, temp)
end

function CSharpCallLuaInterface.GetTemperatureTextColor(temp)
  return DataCenter.TemperatureTemplateManager:GetTextColor(temp)
end

function CSharpCallLuaInterface.OnWorldBaseRefresh(buildPointInfo)
  DataCenter.BuildEffectManager:OnWorldBaseRefresh(buildPointInfo)
  BaseBuildingEffectManager:GetInstance():OnWorldBaseRefresh(buildPointInfo)
  BuildFireEffectManager:GetInstance():OnWorldBaseRefresh(buildPointInfo)
  BuildTopBubbleManager:GetInstance():OnWorldBaseRefresh(buildPointInfo)
  CityDomeProtectEffectManager:GetInstance():OnWorldBaseRefresh(buildPointInfo)
end

function CSharpCallLuaInterface.OnWorldBasePlayDisco(buildingUuid, pointId, et)
  BaseBuildingDiscoManager:GetInstance():AddDiscoBuildEffect(buildingUuid, pointId, et)
end

function CSharpCallLuaInterface.OnWorldBaseFirework(buildingUuid, pointId, et)
  BaseBuildingDiscoManager:GetInstance():AddFireworkEffect(buildingUuid, pointId, et)
end

function CSharpCallLuaInterface.OnWorldBasePlayDiscoShowTips(tipsStr)
  UIUtil.ShowTips(tipsStr)
end

function CSharpCallLuaInterface.OnWorldRuinRefresh(buildPointInfo)
  BuildFireEffectManager:GetInstance():OnWorldBaseRefresh(buildPointInfo)
end

function CSharpCallLuaInterface.WorldMarchPushHandle(message)
  DataCenter.WorldMarchDataManager:WorldMarchPushHandle(message)
end

function CSharpCallLuaInterface.WorldMarchUpdateHandle(message)
  DataCenter.WorldMarchDataManager:WorldMarchUpdateHandle(message)
end

function CSharpCallLuaInterface.WorldMarchDeleteHandle(uuid)
  DataCenter.WorldMarchDataManager:WorldMarchDeleteHandle(uuid)
end

function CSharpCallLuaInterface.WorldMarchGetHandle(message)
  DataCenter.WorldMarchDataManager:WorldMarchGetHandle(message)
end

function CSharpCallLuaInterface.RefreshAllyDrillBase(march)
  DataCenter.AllyDrillBaseManager:RefreshAllyDrillBase(march)
end

function CSharpCallLuaInterface.GetShowObjectModelParam()
  return DataCenter.CollectResourceManager:GetShowObjectModelParam()
end

function CSharpCallLuaInterface.GetResourceTypeByBuildId(buildId)
  return DataCenter.BuildManager:GetResourceTypeByBuildId(buildId)
end

function CSharpCallLuaInterface.GetCollectRangeInfoByIndex(index)
  return DataCenter.CollectResourceManager:GetCollectRangeInfoByIndex(index)
end

function CSharpCallLuaInterface.GetLodTemplates(lodType)
  return DataCenter.WorldLodManager:GetTemplatesByType(lodType)
end

function CSharpCallLuaInterface.GetAllLodTemplates()
  return DataCenter.WorldLodManager:GetAllTemplates()
end

function CSharpCallLuaInterface.GetDomeRange()
  return DataCenter.CityDomeManager:GetDomeRangeCache()
end

function CSharpCallLuaInterface.GetShowRoadDataByPointId(pointId)
  return DataCenter.BoardManager:GetShowRoadDataByPointId(pointId)
end

function CSharpCallLuaInterface.GetAllPathRoadData()
  return DataCenter.BoardManager:GetAllPathRoadData()
end

function CSharpCallLuaInterface.GetPathRoadData(pointId)
  return DataCenter.BoardManager:GetPathRoadData(pointId)
end

function CSharpCallLuaInterface.GetFlagPath(allianceId, srcServerId)
  if not string.IsNullOrEmpty(allianceId) then
    if allianceId == LuaEntry.Player:GetAllianceUid() or DataCenter.SeasonAllyFriendManager:IsMyFriendAlly(allianceId) then
      return "Assets/Main/Prefabs/BuildEffect/Crossing_flag_blue.prefab"
    elseif allianceId == DataCenter.AllianceCompeteDataManager:GetFightAllianceId() then
      return "Assets/Main/Prefabs/BuildEffect/Crossing_flag_red.prefab"
    end
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if srcServerId ~= mySourceServerId then
    local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
    if seasonInfo and seasonInfo:IsInBattleServerGroupInt(srcServerId) then
      local seasonType = seasonInfo:GetServerSubdivisionType(false)
      if seasonType == SeasonMapType.NineNationRainforest then
        local campId1 = seasonInfo:GetCampIdByServerId(mySourceServerId)
        local campId2 = seasonInfo:GetCampIdByServerId(srcServerId)
        if campId1 and campId2 and campId1 == campId2 then
          return "Assets/Main/Prefabs/BuildEffect/Crossing_flag_yellow.prefab"
        end
      end
    end
    return "Assets/Main/Prefabs/BuildEffect/Crossing_flag_red.prefab"
  end
  return "Assets/Main/Prefabs/BuildEffect/Crossing_flag_yellow.prefab"
end

function CSharpCallLuaInterface.GetOnMovingBuildUuid()
  return DataCenter.BuildManager:GetOnMovingBuildUuid()
end

function CSharpCallLuaInterface.MarchErrorLog(message)
  CommonUtil.MarchErrorLog(message)
end

function CSharpCallLuaInterface.GetBlackLandSpeed()
  return DataCenter.BirthPointTemplateManager:GetBlackLandSpeedByServerId(LuaEntry.Player:GetCurServerId())
end

function CSharpCallLuaInterface.GetActivityBossShout()
  return DataCenter.ActBossDataManager:GetWorldBossShoutData()
end

function CSharpCallLuaInterface.GetActivityBossRotation()
  return DataCenter.ActBossDataManager:FetchConfig("boss_rotation", nil)
end

function CSharpCallLuaInterface.GetBlackLandMaxSpeed()
  return DataCenter.BirthPointTemplateManager:GetBlackLandMaxSpeed()
end

function CSharpCallLuaInterface.GetCanShowBlackLand()
  return true
end

function CSharpCallLuaInterface.GetBlackLandRange()
  local a, b, c, d = DataCenter.BirthPointTemplateManager:GetBlackLandRange()
  local minX = math.min(a.x, b.x)
  local maxX = math.max(a.x, b.x)
  local minY = math.min(a.y, c.y)
  local maxY = math.max(a.y, c.y)
  return {
    minX,
    maxX,
    minY,
    maxY
  }
end

function CSharpCallLuaInterface.ParkourUnlock()
  if DataCenter.ParkourManager.GMUnlock then
    DataCenter.ParkourManager.GMUnlock = false
  else
    DataCenter.ParkourManager.GMUnlock = true
  end
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIParkourMap)
  if window then
    window.View:RefreshView()
  end
end

function CSharpCallLuaInterface.ChangeScene(toWorld)
  if toWorld then
    DataCenter.LWSceneStateManager:ChangeScene(SceneType.World)
    EventManager:GetInstance():Broadcast(EventId.GF_enter_world)
  else
    DataCenter.LWSceneStateManager:ChangeScene(SceneType.City)
    EventManager:GetInstance():Broadcast(EventId.GF_enter_city)
  end
  CommonUtil.PlayGameBgMusic()
end

function CSharpCallLuaInterface.GetKingCityPointId(serverId)
  local _, pointIndex = SeasonUtil.GetKingCityId(serverId)
  return pointIndex
end

function CSharpCallLuaInterface.GetHSRWaitTime()
  return DataCenter.HSRDataManager:GetHSRWaitTime()
end

function CSharpCallLuaInterface.HandelSeasonGetZoneTrainActivityInfo(t)
  DataCenter.HSRDataManager:HandelActivityData(t)
end

function CSharpCallLuaInterface.AddOrRefreshHSR()
  DataCenter.HSRViewManager:AddOrRefreshHSR()
end

function CSharpCallLuaInterface.AddOrUpdateTrain(train)
  DataCenter.LWTrainDataManager:AddOrUpdateTrain(train)
end

function CSharpCallLuaInterface.CreateTrain(march, parent)
  DataCenter.LWTrainManager:CreateTrain(march, parent)
end

function CSharpCallLuaInterface.RefreshTrain(march)
  DataCenter.LWTrainManager:RefreshTrain(march)
end

function CSharpCallLuaInterface.RemoveTrain(uuid)
  DataCenter.LWTrainManager:RemoveTrain(uuid)
end

function CSharpCallLuaInterface.HandleDepartureTrain(msg)
  RailwayUtil.HandleDepartureTrain(msg)
end

function CSharpCallLuaInterface.HandleDepartureTrainList(msg)
  RailwayUtil.HandleDepartureTrainList(msg)
end

function CSharpCallLuaInterface.UpdateFlowerTrainData(march)
  DataCenter.FlowerTrainDataManager:UpdateFlowerTrainData(march)
end

function CSharpCallLuaInterface.CreateFlowerTrain(march, parent, followCamera)
  DataCenter.FlowerTrainGroupManager:CreateFlowerTrain(march, parent, followCamera)
end

function CSharpCallLuaInterface.RefreshFlowerTrain(march)
  DataCenter.FlowerTrainGroupManager:RefreshFlowerTrain(march)
end

function CSharpCallLuaInterface.RemoveFlowerTrain(uuid)
  DataCenter.FlowerTrainGroupManager:RemoveFlowerTrain(uuid)
end

function CSharpCallLuaInterface.CreateAllianceBuildSquad(pointId, parent, isCreate)
  DataCenter.WorldFakeBattleManager:CreateAllianceBuildSquad(pointId, parent, isCreate)
end

function CSharpCallLuaInterface.RemoveAllianceBuildSquad(pointId)
  DataCenter.WorldFakeBattleManager:RemoveAllianceBuildSquadByPoint(pointId)
end

function CSharpCallLuaInterface.CreateWorldSquad(uuid, parent, collider)
  DataCenter.WorldBattleManager:CreateSquad(uuid, parent, collider)
end

function CSharpCallLuaInterface.WorldSquadPlayAnim(uuid, anim, rewind)
  DataCenter.WorldBattleManager:PlayAnim(uuid, anim, rewind)
end

function CSharpCallLuaInterface.WorldSquadRefreshMummyMarchSkin(uuid)
  DataCenter.WorldBattleManager:WorldSquadRefreshMummyMarchSkin(uuid)
end

function CSharpCallLuaInterface.WorldSquadRefreshMeteorite(uuid)
  DataCenter.WorldBattleManager:WorldSquadRefreshMeteorite(uuid)
end

function CSharpCallLuaInterface.WorldSquadSetRotation(uuid, quat)
  DataCenter.WorldBattleManager:SetRotation(uuid, quat)
end

function CSharpCallLuaInterface.WorldSquadAttack(uuid, targetPos, index)
  DataCenter.WorldBattleManager:Attack(uuid, targetPos, index)
end

function CSharpCallLuaInterface.RemoveWorldSquad(uuid)
  DataCenter.WorldBattleManager:RemoveSquad(uuid)
end

function CSharpCallLuaInterface.RemoveScoutSticker(uuid)
  DataCenter.LWSticker3DManager:RemoveScoutSticker(uuid)
end

function CSharpCallLuaInterface.PVEJumpLevel(levelId)
  DataCenter.LWBattleManager:JumpLevel(levelId)
end

function CSharpCallLuaInterface.PlayReplay(mailUid)
  DataCenter.LWBattleManager:PlayReplay(mailUid, PVEEnterType.GM)
end

function CSharpCallLuaInterface.PlayLastReplay()
  DataCenter.LWBattleManager:PlayLastReplay()
end

function CSharpCallLuaInterface.GetWorldDetectBgById(eventId)
  local imgPath = ""
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if IsNull(template) then
    return imgPath
  end
  imgPath = DetectEvenColorImage[template.quality]
  return imgPath
end

function CSharpCallLuaInterface.GetWorldFakePlayerDetectBgById(eventId)
  local imgPath = ""
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if IsNull(template) then
    return imgPath
  end
  imgPath = DetectEvenFakePlayerColorImage[template.quality]
  return imgPath
end

function CSharpCallLuaInterface.GetWorldDetectIconById(eventId)
  local imgPath = ""
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if IsNull(template) then
    return imgPath
  end
  if template.type == DetectEventType.FAKE_PLAYER then
    local imgName = template.icon
    imgPath = string.format(LoadPath.UIPlayerIcon, imgName)
    return imgPath
  end
  local appearenceId = template.appearance_id
  if appearenceId == 0 then
    if not string.IsNullOrEmpty(template.icon_custom) then
      imgPath = template.icon_custom
    else
      imgPath = string.format(LoadPath.RadarCenterPath, template.icon)
    end
  else
    imgPath = HeroUtils.GetHeroIconPath(appearenceId)
  end
  return imgPath
end

function CSharpCallLuaInterface.GetWorldDetectIconHighById(eventId)
  local high = 0.11
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if IsNull(template) then
    return high
  end
  high = template.world_icon_height
  return high
end

function CSharpCallLuaInterface.IsMyAllianceMemberByUid(uid)
  return DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid) ~= nil
end

function CSharpCallLuaInterface.IsMemberHouse(pointId)
  return DataCenter.AllianceMemberDataManager:IsMemberHouse(pointId)
end

function CSharpCallLuaInterface.GetAllianceMembersHomePos()
  return DataCenter.AllianceMemberDataManager:GetAllianceMembersHomePos()
end

function CSharpCallLuaInterface.UseLuaTroopLine()
  return false
end

function CSharpCallLuaInterface.UseMarchDataPool()
  return false
end

function CSharpCallLuaInterface.IsMarchStateDebugLogOpened()
  return true
end

function CSharpCallLuaInterface.GetLockAoiUpdateCamSpeed()
  return 70
end

function CSharpCallLuaInterface.CreateTroopLine(march)
  DataCenter.WorldTroopLineManager:CreateTroopLine(march)
end

function CSharpCallLuaInterface.DestroyTroopLine(uuid)
  DataCenter.WorldTroopLineManager:DestroyTroopLine(uuid)
end

function CSharpCallLuaInterface.UpdateTroopLineNew(march, currPos)
  return DataCenter.WorldTroopLineManager:UpdateTroopLineNew(march, currPos)
end

function CSharpCallLuaInterface.OnLaunchMarchSuccess(marchTargetType, targetUuid, targetPos)
  MarchUtil.OnLaunchMarchSuccess(marchTargetType, targetUuid, targetPos)
end

function CSharpCallLuaInterface.GetProductFlyTxtAniIntervalTime()
  return 1
end

function CSharpCallLuaInterface.GetResourceIconByType(resType)
  local icon = DataCenter.ResourceManager:GetResourceIconByType(resType)
  return icon
end

function CSharpCallLuaInterface.GetResourceDetectCollectingIcon()
  return "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_26"
end

function CSharpCallLuaInterface.GetResourceDetectInfoIconBgById(ResId)
  local imgPath = ""
  local template = DataCenter.GatherResourceTemplateManager:GetTemplate(ResId)
  if IsNull(template) then
    return imgPath
  end
  imgPath = DetectResourceCollectColorImage[template.quality]
  return imgPath
end

function CSharpCallLuaInterface.GetDetectEventIdByPointId(pointId)
  local eventId = ""
  local eventInfo = DataCenter.RadarCenterDataManager:GetEventInfoByPointId(pointId)
  if eventInfo then
    eventId = tostring(eventInfo.eventId)
  end
  return eventId
end

function CSharpCallLuaInterface.GetDetectEventModelByUuid(uuid)
  local modelName = ""
  local eventInfo = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if eventInfo then
    local eventId = tostring(eventInfo.eventId)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
    if template ~= nil and template.type == DetectEventType.FAKE_PLAYER then
      local simplayer = template.para
      local playerConfig = LocalController:instance():getLine(TableName.LW_SIMPLAYER, simplayer)
      if not string.IsNullOrEmpty(playerConfig.model) then
        modelName = playerConfig.model
      end
    end
  end
  return modelName
end

function CSharpCallLuaInterface.SetMyBaseWormWrap(expireTime, monsterId)
  if not DataCenter.JungleTrialDataManager:IsChomper(monsterId) then
    DataCenter.SandWormHuntDataManager:SetMyBaseWormWrap(expireTime, monsterId)
  end
end

function CSharpCallLuaInterface.ShowMyBaseWormAppearTip(monsterId)
  if DataCenter.JungleTrialDataManager:IsChomper(monsterId) then
    UIUtil.ShowTipsId("season6_piranha_activity_swallow_desc")
  elseif DataCenter.AllyDrillDataManager:IsMonsterBossSandWormCall(monsterId) then
    UIUtil.ShowTipsId("new_alliance_boss_tips_24")
  else
    UIUtil.ShowTipsId("season_activity_1000069_desc32")
  end
end

function CSharpCallLuaInterface.GetDetectEventTreasureIcon(eventId)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if template and template:JudgeIsDroneTreasure() then
    return "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_27"
  end
  return "Assets/Main/Sprites/UI/UIRadarCenter/cfm_leida_qipao_26"
end

function CSharpCallLuaInterface.GetDetectEventTreasureNameDes(eventId, nameStr)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if template and template:JudgeIsDroneTreasure() then
    return Localization:GetString("detect_event_objname_1901", nameStr)
  elseif template and (template.type == DetectEventType.TREASURE_ACTIVITY or template.type == DetectEventType.OFF_SEASON_TREASURE) then
    return Localization:GetString("activity_wajueji_27000_tips14", nameStr)
  end
  return Localization:GetString("801344", nameStr)
end

function CSharpCallLuaInterface.OnGotoSpecialWorld()
  local worldId = 0
  local worldType = 0
  local serverId = 0
  local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
  if crossBuildData ~= nil then
    worldId = crossBuildData.worldId or LuaEntry.Player:GetCurWorldId()
    worldType = crossBuildData.worldType or LuaEntry.Player:GetCurWorldType()
    serverId = crossBuildData.server
    if worldId ~= nil and 0 < worldId then
      local pointId = crossBuildData.pointId
      local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      position.x = position.x - 1
      position.z = position.z - 1
      CrossServerUtil.OnGotoDragonWorld(serverId, worldId, worldType, position)
      CS.SceneManager.World:Lookat(position)
    end
  end
end

function CSharpCallLuaInterface.TryShowChangeToSingleServerModeTips()
  SeasonUtil.TryShowChangeToSingleServerModeTips()
end

function CSharpCallLuaInterface.IsSeasonInSingleServerMode(serverId)
  return SeasonUtil.IsSeasonInSingleServerMode(serverId)
end

function CSharpCallLuaInterface.TestButton1(inputStr)
  if string.IsNullOrEmpty(inputStr) then
    return
  end
  BattleReportUtil.Create(inputStr, PVEEnterType.Debug, true)
end

function CSharpCallLuaInterface.TestButton2()
  local activityServerData = {}
  activityServerData.actFightStep = 0
  activityServerData.round = 1
  activityServerData.fightStartTime = 9715760660000
  DataCenter.GovernmentManager.activityServerData = activityServerData
  DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGovernmentActivityPopup, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

function CSharpCallLuaInterface.TestButton3()
  DataCenter.MasteryManager:InitMeta()
end

function CSharpCallLuaInterface.TestButton4()
  DataCenter.GovernmentManager:UICrossThroneSuccessPop()
end

function CSharpCallLuaInterface.GetLWAoiBlockSizeArray()
  return LWAoiBlockSizeArray
end

function CSharpCallLuaInterface.GetUseLWAoi()
  return true
end

function CSharpCallLuaInterface.GetCityBuildingModelName(buildId, buildLevel)
  return BuildingUtils.GetCityBuildingModelName(buildId, buildLevel)
end

function CSharpCallLuaInterface.GetCityMainSkinId()
  local skinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  if skinId == nil then
    skinId = 0
  end
  return skinId
end

function CSharpCallLuaInterface.GetWorldDefaultNameBgSkin()
  return "appellation_icon_arena"
end

function CSharpCallLuaInterface.GetTitleNameDeltaX(skinId)
  if skinId ~= 0 then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if template then
      return template.titlePosOffset
    else
      return 0.4
    end
  else
    return 0
  end
end

function CSharpCallLuaInterface.GetWorldNameBgSize(skinId)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if template then
    return template.titleSizeAdd
  end
  return 1.5
end

function CSharpCallLuaInterface.CreateAllyDrillBase(march, transform)
  DataCenter.AllyDrillBaseManager:CreateAllyDrillBase(march, transform)
end

function CSharpCallLuaInterface.RemoveAllyDrillBase(uuid)
  DataCenter.AllyDrillBaseManager:RemoveAllyDrillBase(uuid)
end

function CSharpCallLuaInterface.CreateMovingModelFinished(flag, transform)
  if flag then
    if flag == FakeMovingModelFlag.Aisilla then
      DataCenter.InvasionAisillaCtrlManager:CreateMovingModel(transform)
    elseif flag == FakeMovingModelFlag.ZMBoss then
      DataCenter.ZoneMobilizationCtrlManager:CreateMovingModel(transform)
    elseif flag == FakeMovingModelFlag.KirovLaunchStation then
      DataCenter.WorldMoveModelCtrlManager:CreateMovingModel(transform)
    elseif flag == FakeMovingModelFlag.S0AllianceBuilding then
      DataCenter.WorldMoveModelCtrlManager:CreateMovingModel(transform)
    end
  end
end

function CSharpCallLuaInterface.CreateAisillaCtrl(march, transform)
  if march then
    DataCenter.ActivityMonsterInvasionDataManager:OnAisillaMarchCreated(march.uuid)
    DataCenter.InvasionAisillaCtrlManager:CreateAisillaCtrl(march, transform)
  end
end

function CSharpCallLuaInterface.RemoveAisillaCtrl(uuid)
  DataCenter.InvasionAisillaCtrlManager:RemoveAisillaCtrl(uuid)
end

function CSharpCallLuaInterface.RefreshAisilaCtrl(march)
  DataCenter.InvasionAisillaCtrlManager:RefreshAisilaCtrl(march)
end

function CSharpCallLuaInterface.PlayPlotBubble3D(type, marchInfo, transform, duration)
  DataCenter.ActivityMonsterInvasionDataManager:PlayPlotBubble3D(type, marchInfo, transform, duration)
end

function CSharpCallLuaInterface.PlayPlotBubble3DOfRunningBoss(marchInfo, transform, duration)
  DataCenter.LWDoomsdayManager:PlayPlotBubble3D(marchInfo, transform, duration)
end

function CSharpCallLuaInterface.GetBossSpeakMark(marchUuid)
  return DataCenter.ActivityMonsterInvasionDataManager:GetBossTroopSpeak(marchUuid)
end

function CSharpCallLuaInterface.CreateMoveDrillBase(march, transform)
  DataCenter.AllyDrillBaseManager:CreateMoveDrillBase(march, transform)
end

function CSharpCallLuaInterface.RemoveMoveDrillBase()
  DataCenter.AllyDrillBaseManager:RemoveMoveDrillBase()
end

function CSharpCallLuaInterface.GetDefaultNation()
  return DefaultNation
end

function CSharpCallLuaInterface.IsInSeason()
  return SeasonUtil.CurServerIsInSeason()
end

function CSharpCallLuaInterface.IsInSameSeasonGroup(serverId)
  return SeasonUtil.IsInSameGroup(serverId)
end

function CSharpCallLuaInterface.GetAllNationFlags()
  return DataCenter.NationTemplateManager:GetAllNationFlagList()
end

function CSharpCallLuaInterface.GetLowFpsConfig()
  return DisplaySettings.GetLowFpsConfig()
end

function CSharpCallLuaInterface.GetWorldStaticObjectCreateCountPerFrame()
  return 3
end

function CSharpCallLuaInterface.GetMarchPrefabPath(marchTargetType)
  local path = ""
  if marchTargetType == MarchTargetType.NORMAL_FAKE_MARCH then
    path = "Assets/Main/Prefabs/March/WorldTroopHelper.prefab"
  elseif marchTargetType == MarchTargetType.SCOUT_FAKE_MARCH then
    path = "Assets/Main/Prefabs/March/WorldTroopScout.prefab"
  elseif marchTargetType == MarchTargetType.RESCUE_FAKE_MARCH then
    path = "Assets/Main/Prefabs/March/WorldTroopDetectRescue.prefab"
  end
  return path
end

function CSharpCallLuaInterface.GetDetectTreasureReward(posIndex)
  UIUtil.GetDetectTreasureReward(posIndex)
  return 0
end

function CSharpCallLuaInterface.IsS1SeasonPreBoss(monsterId)
  if not DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    return false
  end
  local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
  if not actBoss or not seasonBoss then
    return false
  end
  return actBoss.monsterId == monsterId or seasonBoss.monsterId == monsterId
end

function CSharpCallLuaInterface.GetS1SeasonPreBossAIConfig(monsterId)
  local aiConfig = {}
  if not DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    return aiConfig
  end
  local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
  if not actBoss or not seasonBoss then
    return aiConfig
  end
  local speakInterval = GetTableData(TableName.DataConfig, "s1_pre_activity_config", "k3")
  local attackInterval = GetTableData(TableName.DataConfig, "s1_pre_activity_config", "k4")
  if monsterId == actBoss.monsterId then
    aiConfig = {speakInterval, attackInterval}
  elseif monsterId == seasonBoss.monsterId then
    aiConfig = {speakInterval, attackInterval}
  end
  return aiConfig
end

function CSharpCallLuaInterface.GetS1SeasonPreBossSpeakByType(monsterId, speakType)
  local speakList = {}
  if not DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    return {}
  end
  local configData = DataCenter.LWSeasonBossLoginDataManager.configData
  if not configData then
    return {}
  end
  local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
  if not actBoss or not seasonBoss then
    return {}
  end
  if monsterId == actBoss.monsterId then
    local oldBossSpeak = configData:getValue("boss_shout_old")
    speakList = oldBossSpeak
  elseif monsterId == seasonBoss.monsterId then
    local newBossSpeak = configData:getValue("boss_shout_new")
    speakList = newBossSpeak
  end
  local speaks = string.split(speakList, "|")
  if speaks == nil or #speaks == 0 then
    return {}
  end
  if speakType > #speaks then
    return {}
  end
  local typeSpeaks = speaks[speakType]
  speakList = string.split(typeSpeaks, ";")
  return speakList
end

function CSharpCallLuaInterface.IsWeakS1SeasonPreBoss(monsterId)
  local weak = false
  if not DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    return weak
  end
  local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
  if not actBoss or not seasonBoss then
    return weak
  end
  if monsterId == actBoss.monsterId then
    weak = actBoss.monsterJson.state == 1
  elseif monsterId == seasonBoss.monsterId then
    weak = seasonBoss.monsterJson.state == 1
  end
  return weak
end

function CSharpCallLuaInterface.CheckCanToPlayerS1SeasonPreBossCirHit()
  return DataCenter.LWSeasonBossLoginDataManager:CheckCanToPlayerS1SeasonPreBossCirHit()
end

function CSharpCallLuaInterface.GetTodayCanShowSecondConfirm(showType)
  return DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(showType)
end

function CSharpCallLuaInterface.SetTodayNoShowSecondConfirm(showType, isNoShow)
  return DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(showType, isNoShow)
end

function CSharpCallLuaInterface.GetDetectTreasureRewardBg(isHaveReward)
  local imgPath = ""
  if isHaveReward then
    imgPath = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_1"
  else
    imgPath = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_lan"
  end
  return imgPath
end

function CSharpCallLuaInterface.IsFromBIGCHINAorUsingLangZH()
  return LuaEntry.Player:IsFromBIGCHINAorUsingLangZH()
end

function CSharpCallLuaInterface.GetWorldExploreDetectEventModel(eventId)
  local path = ""
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if template then
    local modelName = template.image
    path = string.format("Assets/Main/Prefabs/Garbage/%s.prefab", modelName)
  end
  return path
end

function CSharpCallLuaInterface.GetCrossFightServerInfo()
  return DataCenter.ZoneWarManager:GetCrossFightServerInfo()
end

function CSharpCallLuaInterface.GetAllianceBuildTileIndex(buildId, index, buildTopType)
  return WorldAllianceBuildUtil.GetBuildTileIndex(buildId, index, buildTopType)
end

function CSharpCallLuaInterface.IsCanPutDownByAllianceBuild(buildId, index)
  return WorldAllianceBuildUtil.IsCanPutDownByAllianceBuild(buildId, index)
end

function CSharpCallLuaInterface.GetBuildMainVecByModelCenter(centerIndex, tile)
  return BuildingUtils.GetBuildMainVecByModelCenter(centerIndex, tile)
end

function CSharpCallLuaInterface.ShowUIPrivacy(mode)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPrivacy, {anim = false, immediately = true}, mode)
end

function CSharpCallLuaInterface.ShowUIPrivacyKR(mode)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPrivacyKR, {anim = false, immediately = true}, mode)
end

function CSharpCallLuaInterface.ShowDMA()
  local isShow = IsShowDMAType.NotShow
  local isIos = SDKManager.IS_IPhonePlayer()
  local confirmV3 = Setting:GetBool(PrivacyKey.V3)
  if not confirmV3 then
    isShow = IsShowDMAType.Show
  end
  return isShow
end

function CSharpCallLuaInterface.SetPrivacyKey()
  Setting:SetBool(PrivacyKey.V3, true)
end

function CSharpCallLuaInterface.ShowPrivacy(show)
  local result = 1
  local isIos = SDKManager.IS_IPhonePlayer()
  local isConfirmed = CSharpCallLuaInterface.IsPrivacyConfirmed()
  local isKr = CS.GameEntry.Device:IsKR()
  local show = show
  if isKr and not isConfirmed then
    CSharpCallLuaInterface.ShowUIPrivacyKR(show)
  else
    CSharpCallLuaInterface.ShowUIPrivacy(show)
  end
  return result
end

function CSharpCallLuaInterface.IsPrivacyConfirmed()
  local isIos = SDKManager.IS_IPhonePlayer()
  local confirmV1 = Setting:GetBool(PrivacyKey.V1)
  local confirmV2 = Setting:GetBool(PrivacyKey.V2)
  local confirmV2IOS = Setting:GetBool(PrivacyKey.IOSV2)
  local isConfirmed = false
  if confirmV1 or isIos and confirmV2IOS or not isIos and confirmV2 then
    isConfirmed = true
  end
  return isConfirmed
end

function CSharpCallLuaInterface.HasWorldBattleProcess(marchUuid)
  local squad = DataCenter.WorldBattleManager:GetSquad(marchUuid)
  if squad then
    return require("DataCenter.WorldBattle.WorldBattleDisplaySettings").HasBattleProcess(squad.displayLevel)
  else
    return false
  end
end

function CSharpCallLuaInterface.RandomHeroIdsAndTacWeaponInfo()
  if not CSharpCallLuaInterface.__heroTemplateIdsCache then
    local datas = HeroUtils.GenerateHeroDataList(0)
    CSharpCallLuaInterface.__heroTemplateIdsCache = {}
    for _, id in ipairs(datas) do
      local hero = DataCenter.HeroDataManager:GetHeroByUuid(id)
      if hero then
        table.insert(CSharpCallLuaInterface.__heroTemplateIdsCache, hero.heroId)
      end
    end
  end
  local result = {}
  for i = 1, 5 do
    result["heroId_" .. i] = CSharpCallLuaInterface.__heroTemplateIdsCache[math.random(1, #CSharpCallLuaInterface.__heroTemplateIdsCache)]
  end
  result.weaponId = 1000
  result.weaponLv = 1
  return result
end

function CSharpCallLuaInterface.GetActivityDropMonsterModel(id)
  id = tonumber(id)
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  for _, v in pairs(activityList) do
    if v.tableInfo == "activity_drop" then
      local dropId = v.subType
      local templateList = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(tonumber(dropId))
      for __, v1 in pairs(templateList) do
        if not table.IsNullOrEmpty(v1.boss_id) then
          for i = 1, #v1.boss_id do
            if id >= v1.boss_id[i][1] and id <= v1.boss_id[i][2] then
              if #v1.monster_model == 1 then
                return v1.monster_model[1]
              else
                return i <= #v1.monster_model and v1.monster_model[i] or ""
              end
            end
          end
        end
      end
    end
  end
end

function CSharpCallLuaInterface.GetActivityDropEffect(id, curPrefab)
  id = tonumber(id)
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  for _, v in pairs(activityList) do
    if v.tableInfo == "activity_drop" then
      local dropId = v.subType
      local templateList = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(tonumber(dropId))
      local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(id, false)
      for _, v1 in pairs(templateList) do
        if v1:CheckTypeAndSpecial(monsterTemplate.type, monsterTemplate.special) and monsterTemplate.model_name == curPrefab and not string.IsNullOrEmpty(v1.monster_vfx[1]) then
          return v1.monster_vfx[1]
        end
      end
    end
  end
  return ""
end

function CSharpCallLuaInterface.GetActivityRadarDigModel()
  return DataCenter.ActivityListDataManager:GetActivityRadarDigModel()
end

function CSharpCallLuaInterface.GetTroopTargetPointId(uuid)
  return DataCenter.AllianceWarDataManager:GetTroopTargetPointId(uuid)
end

function CSharpCallLuaInterface.OpenDelAccountSuccessView()
  CS.UnityEngine.PlayerPrefs.DeleteAll()
  UIUtil.ShowMessage(Localization:GetString("delete_account_content_11"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    CS.ApplicationLaunch.Instance:Quit()
  end, function()
    CS.ApplicationLaunch.Instance:Quit()
  end, nil, "delete_account_title_01")
end

function CSharpCallLuaInterface.StopPlayLoopSoundWithLimit(id, timer)
  local limitType = SoundIdToLimitType[id]
  if limitType then
    return DataCenter.LWSoundManager:StopPlayLoopSoundWithLimit(limitType, timer)
  end
end

function CSharpCallLuaInterface.CreateWarEffect(warEffectList, serverId, worldId)
  return DataCenter.AllianceSkillManager:CreateWarEffect(warEffectList, nil, serverId, worldId)
end

function CSharpCallLuaInterface.UpdateProtectedCityInfos(dataList, _serverId, _worldId)
  if dataList then
    local protectList = {}
    for k, v in pairs(dataList) do
      protectList[v.id] = v.protectTime
    end
    local serverId = _serverId or LuaEntry.Player:GetCurServerId()
    DataCenter.AllianceCityTipManager:UpdateProtectedTime(serverId, protectList)
  end
end

function CSharpCallLuaInterface.CreateWarFlags(flagDataList)
  return DataCenter.WarFlagDataManager:CreateWarFlags(flagDataList)
end

function CSharpCallLuaInterface.HandleHeatSource(heatSourceList)
  return DataCenter.WarFlagDataManager:HandleWorldGetBlock(heatSourceList)
end

function CSharpCallLuaInterface.GetWarFlagGroup()
  return DataCenter.WarFlagDataManager:GetWarFlagGroup()
end

function CSharpCallLuaInterface.GetPlayerMaxHp(bfType)
  return BattleFieldUtil.GetPlayerMaxHp(bfType)
end

function CSharpCallLuaInterface.GetBattleFieldWorldSize(bfType)
  local x, y = BattleFieldUtil.GetBattleFieldWorldSize(bfType)
  return {x = x, y = y}
end

function CSharpCallLuaInterface.GetBattleFieldRange(bfType)
  return BattleFieldUtil.GetBattleFieldRange(bfType)
end

function CSharpCallLuaInterface.GetBattleFieldMiniMapSpritePath(detailInfo, bfType)
  return BattleFieldUtil.GetMiniMapSpritePath(detailInfo, bfType, true)
end

function CSharpCallLuaInterface.GetBattlefieldPreviewSpritePath(detailInfo, bfType)
  return BattleFieldUtil.GetBattlefieldPreviewSpritePath(detailInfo, bfType, true)
end

function CSharpCallLuaInterface.GetBattleFieldEntityCfgName(bfType)
  return BattleFieldUtil.GetBattleFieldCfgValue(bfType, BattleFieldTableKey.ENTITY) or ""
end

function CSharpCallLuaInterface.UpdateBattleFieldAnim(pointIndex, bfType)
  DataCenter.BattleFieldAnimManager:UpdateObjAnim(pointIndex, bfType)
end

function CSharpCallLuaInterface.UpdateBattleFieldSkill(ownerUid, skillId, pointIndex, gameObject)
  DataCenter.BattleFieldAnimManager:UpdateObjSkill(ownerUid, skillId, pointIndex, gameObject)
end

function CSharpCallLuaInterface.GetWorldCampInBattleField(marchUuid, bfType)
  return BattleFieldUtil.GetWorldCampInBattleField(marchUuid, bfType)
end

function CSharpCallLuaInterface.GetEpidemicTeammateByAllianceId(allianceId)
  return DataCenter.ActEpidemicZoneManager:GetTeammateByAllianceId(allianceId)
end

function CSharpCallLuaInterface.GetEpidemicSkillModelPath(skillId)
  return DataCenter.ActEpidemicZoneManager:GetSkillModelPath(skillId)
end

function CSharpCallLuaInterface.GetEpidemicCurSkillInfo()
  return DataCenter.ActEpidemicZoneManager:GetEpidemicCurSkillInfo()
end

function CSharpCallLuaInterface.IsBattleFieldEnemy(param, bfType)
  return BattleFieldUtil.IsBattleFieldEnemy(param, bfType)
end

function CSharpCallLuaInterface.GetBattlefieldBuildingColor(pointIndex, worldType, role)
  if worldType == BattleFieldType.DsbDuel then
    return BattlefieldDsbDuelUtils.GetBattlefieldBuildingColorIndexByRole(role)
  else
    return 0
  end
end

function CSharpCallLuaInterface.OnSpecialWorldCreate()
  BattleFieldUtil.OnSpecialWorldCreate()
end

function CSharpCallLuaInterface.GetSpecialWorldCreateInfo()
  return BattleFieldUtil.GetSpecialWorldCreateInfo()
end

function CSharpCallLuaInterface.GetALLDragonBuildSize()
  return BattleFieldUtil.GetAllBuildSize()
end

function CSharpCallLuaInterface.GetPlayerSideInBattleField(bfType)
  return BattleFieldUtil.GetPlayerSideInBattleField(bfType)
end

function CSharpCallLuaInterface.OpenPingSign(pointId)
  return BattleFieldUtil.OpenPingSign(pointId)
end

function CSharpCallLuaInterface.GetLabelTextColor(skinId, colorType)
  return DataCenter.DecorationTemplateManager:GetLabelSkinTextColor(skinId, colorType)
end

function CSharpCallLuaInterface.GetFormalDeclareTsByAlliId(allianceId)
  return DataCenter.AllianceDeclareWarManager:GetFormalDeclareTsByAlliId(allianceId)
end

function CSharpCallLuaInterface.GetCityPointIdByAlliId(allianceId)
  return DataCenter.AllianceDeclareWarManager:GetCityPointIdByAlliId(allianceId)
end

function CSharpCallLuaInterface.PlayPlotBubble3DFollow(content, transform, duration)
  local bubbleParams = {}
  bubbleParams.fakePlotMeta = {duration = duration, contentString = content}
  bubbleParams.anchor = Vector3.New(0, 1, 0)
  bubbleParams.mode = "3DFollow"
  bubbleParams.followTarget = transform
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
end

function CSharpCallLuaInterface:GetDeviceLevel()
  if not DisplaySettings then
    return 1
  end
  return DisplaySettings.deviceLevel
end

function CSharpCallLuaInterface.PlayBossAttackPlotBubble(monsterId, transform, offsetX, offsetY)
  local bubbleParams = {}
  local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  bubbleParams.plotGroupId = template:GetAttackPlot()
  bubbleParams.anchor = Vector3.New(offsetX, offsetY, 0)
  bubbleParams.mode = "3DFollow"
  bubbleParams.followTarget = transform
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, bubbleParams)
end

function CSharpCallLuaInterface.PlayWorldBuildTopBubblePlot(plotId, buildUuid, playerUid)
  EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubblePlot, {
    bUuid = buildUuid,
    plotId = plotId,
    playerInfo = {uid = playerUid}
  })
end

function CSharpCallLuaInterface.ShowSiegeCampBubble(position, duration)
  SiegeUtil.ShowSiegeCampBubble(position, duration)
end

function CSharpCallLuaInterface.ShowAllOutHead(marchInfo, duration)
  SiegeUtil.ShowAllOutHead(marchInfo, duration)
end

function CSharpCallLuaInterface.ShowAllOutBubble(marchInfo, duration)
  SiegeUtil.ShowAllOutBubble(marchInfo, duration)
end

function CSharpCallLuaInterface.AllianceCityRefreshFire(cityId, transform)
  DataCenter.AllianceCityTipManager:AllianceCityRefreshFire(cityId, transform)
end

function CSharpCallLuaInterface.AllianceCityRemoveFire(cityId)
  DataCenter.AllianceCityTipManager:AllianceCityRemoveFire(cityId)
end

function CSharpCallLuaInterface.ShowBloodQueenGunnerAttackEffect(cityId, transform)
  DataCenter.AllianceCityTipManager:ShowBloodQueenGunnerAttackEffect(cityId, transform)
end

function CSharpCallLuaInterface.RemoveBloodQueenGunnerAttackEffect(cityId)
  DataCenter.AllianceCityTipManager:RemoveBloodQueenGunnerAttackEffect(cityId)
end

function CSharpCallLuaInterface.GetPlayerFlagPath()
  local countFlag = LuaEntry.Player.countryFlag
  local nationTemp = DataCenter.NationTemplateManager:GetNationTemplate(countFlag)
  if not nationTemp then
    return nil
  end
  local flagPath = nationTemp:GetNationFlagTexPath()
  if string.IsNullOrEmpty(flagPath) then
    return nil
  end
  return flagPath
end

function CSharpCallLuaInterface.GetZombieRushName(templateId)
  local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(templateId)
  if template then
    local nameStr = Localization:GetString(template.name, template.level)
    return nameStr
  end
  return ""
end

function CSharpCallLuaInterface.GetWorldChessColorSetting(serverId, allianceId, uid, currentServerId)
  local cfg = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if cfg then
    return cfg:GetWorldChessColorSetting(serverId, allianceId, uid, currentServerId)
  end
  return nil
end

function CSharpCallLuaInterface.CheckPlayerType(serverId, allianceId, uid, currentServerId)
  local cfg = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if cfg then
    local data = cfg:GetWorldChessColorSetting(serverId, allianceId, uid, currentServerId)
    if data ~= nil then
      return data:ToPlayerType()
    end
  end
  return CSharpCallLuaInterface.IsMyEnemy(serverId, allianceId, currentServerId)
end

local function TryGetLandlordGroupPlayerType(serverId, currentServerId)
  local llMgr = DataCenter.LandlordMgr
  local serverIdAvailable = serverId ~= nil and serverId ~= 0 and serverId ~= ""
  local currentServerIdAvailable = currentServerId ~= nil and currentServerId ~= 0 and currentServerId ~= ""
  if not serverIdAvailable or not currentServerIdAvailable then
    return nil
  end
  if llMgr:IsInCenterServerPeriod() and llMgr:IsInNewCenterMapPeriod() and currentServerId == llMgr:GetCenterServerId() then
    return llMgr:IsSameGroupServer(serverId) and CS.PlayerType.PlayerSeasonCamp or CS.PlayerType.PlayerZoneEnemy
  end
  return nil
end

function CSharpCallLuaInterface.IsMyEnemy(serverId, allianceId, currentServerId)
  local isInSeason = SeasonUtil.IsInSeason()
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if allianceId ~= nil and allianceId ~= "" then
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    if myAllianceId == allianceId then
      return CS.PlayerType.PlayerAlliance
    end
    local isMyFriendAlly = DataCenter.SeasonAllyFriendManager:IsMyFriendAlly(allianceId)
    if isMyFriendAlly then
      return CS.PlayerType.PlayerSeasonAssist
    end
    if serverId ~= nil and currentServerId ~= nil then
      local landlordPlayerType = TryGetLandlordGroupPlayerType(serverId, currentServerId)
      if landlordPlayerType ~= nil then
        return landlordPlayerType
      end
    end
    if DataCenter.AllianceCompeteDataManager:IsBattleDay() and allianceId == DataCenter.AllianceCompeteDataManager:GetFightAllianceId() then
      return CS.PlayerType.PlayerAllianceEnemy
    end
    local inMeteoriteBattleState = MeteoriteBattleUtils.IsInBattleState()
    if inMeteoriteBattleState then
      if serverId == mySourceServerId then
        return CS.PlayerType.PlayerOther
      else
        return CS.PlayerType.PlayerZoneEnemy
      end
    end
    if isInSeason then
      if mySourceServerId ~= serverId and SeasonUtil.IsNineKingActive(serverId, false, true) then
        local kMgr = DataCenter.SeasonNineKingManager
        if kMgr:CanJoinBattle() and kMgr:CanJoinBattle(allianceId) and kMgr:IsCurWorldActive(serverId, true) and not kMgr:IsAlly(allianceId) then
          return CS.PlayerType.PlayerAllianceEnemy
        end
      end
      if seasonType ~= SeasonMapType.NineNationRainforest and SeasonUtil.SeasonHasFactionWar(seasonType) then
        local factionMgr = DataCenter.SeasonFactionWarDataManager
        local myCampId = factionMgr.myCampId
        if myCampId ~= 0 and (factionMgr.currStep == SeasonFactionDeclareWarStep.battle_before or factionMgr.currStep == SeasonFactionDeclareWarStep.battle or factionMgr.currStep == SeasonFactionDeclareWarStep.battle_after) then
          if factionMgr.theAttackerList[myAllianceId] and factionMgr.theAttackerList[allianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theDefenderList[allianceId] then
            return CS.PlayerType.PlayerSeasonAssist
          end
          if factionMgr.theAttackerList[myAllianceId] and factionMgr.theDefenderList[allianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theAttackerList[allianceId] then
            return CS.PlayerType.PlayerAllianceEnemy
          end
        end
      end
    end
  else
    local inMeteoriteBattleState = MeteoriteBattleUtils.IsInBattleState()
    if inMeteoriteBattleState then
      if serverId == LuaEntry.Player:GetSourceServerId() then
        return CS.PlayerType.PlayerOther
      else
        return CS.PlayerType.PlayerZoneEnemy
      end
    end
  end
  if serverId ~= nil and serverId ~= 0 and serverId ~= "" then
    local mySeverId = LuaEntry.Player:GetSourceServerId()
    if mySeverId == serverId then
      if isInSeason and seasonType == SeasonMapType.NineNationRainforest then
        return CS.PlayerType.PlayerSeasonCamp
      elseif isInSeason and SeasonUtil.SeasonHasFactionWar(seasonType) then
        local factionMgr = DataCenter.SeasonFactionWarDataManager
        local myCampId = factionMgr.myCampId
        if myCampId ~= 0 then
          local theCampId = factionMgr:GetCampIdByServerId(serverId)
          if theCampId ~= 0 and myCampId ~= theCampId then
            local debugInfo = factionMgr:CampInfoToString()
            Logger.LogError(string.format("%s,%s,%s;%s", serverId, myCampId, theCampId, debugInfo))
          end
          return CS.PlayerType.PlayerSeasonCamp
        end
      end
      if serverId ~= nil and currentServerId ~= nil then
        local landlordPlayerType = TryGetLandlordGroupPlayerType(serverId, currentServerId)
        if landlordPlayerType ~= nil then
          return landlordPlayerType
        end
      end
      return CS.PlayerType.PlayerOther
    end
    local zMgr = DataCenter.ZoneWarManager
    if zMgr:IsBattleDay() then
      local s1, s2 = zMgr:GetBattleServer()
      if s1 and s2 then
        if zMgr:IsAlly(s1, serverId) and zMgr:IsAlly(s2, mySeverId) or zMgr:IsAlly(s1, mySeverId) and zMgr:IsAlly(s2, serverId) then
          return CS.PlayerType.PlayerZoneEnemy
        end
      elseif zMgr:IsBattleServer(serverId) then
        return CS.PlayerType.PlayerZoneEnemy
      end
    end
    if isInSeason then
      if seasonType == SeasonMapType.NineNationRainforest or SeasonUtil.SeasonHasFactionWar(seasonType) then
        if mySeverId == serverId then
          return CS.PlayerType.PlayerSeasonCamp
        end
        local factionMgr = DataCenter.SeasonFactionWarDataManager
        local myCampId = factionMgr.myCampId
        if myCampId ~= 0 then
          local theCampId = factionMgr:GetCampIdByServerId(serverId)
          if theCampId ~= 0 then
            if myCampId ~= theCampId then
              return CS.PlayerType.PlayerZoneEnemy
            end
            return CS.PlayerType.PlayerSeasonCamp
          end
        end
      end
      if DataCenter.SeasonDataManager:IsInBattleServerGroup(serverId) then
        return CS.PlayerType.PlayerSeasonEnemy
      end
    end
    if serverId ~= nil and currentServerId ~= nil then
      local landlordPlayerType = TryGetLandlordGroupPlayerType(serverId, currentServerId)
      if landlordPlayerType ~= nil then
        return landlordPlayerType
      end
    end
  end
  return CS.PlayerType.PlayerOther
end

function CSharpCallLuaInterface.IsArabicAutoMirrorOpen()
  if CommonUtil then
    return CommonUtil.IsArabicAutoMirrorOpen()
  end
  return false
end

function CSharpCallLuaInterface.GetMarchPointsBySizeAndIndex(uuid, index)
  return WorldMoveMarchUtil.GetMarchPointsBySizeAndIndex(uuid, index)
end

function CSharpCallLuaInterface.FinishedSelectSinglePhotoChat(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
  DataCenter.ChatSendPhotoManager:FinishedSelectSinglePhotoChat(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
end

function CSharpCallLuaInterface.FinishedUploadPhotoChat(ret, resData, uploadPicVer, compressedPhotoPath)
  DataCenter.ChatSendPhotoManager:FinishedUploadPhotoChat(ret, resData, uploadPicVer, compressedPhotoPath)
end

function CSharpCallLuaInterface.FinishedSelectSinglePhotoMoment(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
  DataCenter.ChatSendPhotoManager:FinishedSelectSinglePhotoMoment(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
end

function CSharpCallLuaInterface.FinishedUploadPhotoMoment(ret, resData, uploadPicVer, compressedPhotoPath)
  DataCenter.ChatSendPhotoManager:FinishedUploadPhotoMoment(ret, resData, uploadPicVer, compressedPhotoPath)
end

function CSharpCallLuaInterface.FinishedSelectSinglePhotoChatAllianceNotice(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
  DataCenter.ChatSendPhotoManager:FinishedSelectSinglePhotoChatAllianceNotice(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
end

function CSharpCallLuaInterface.FinishedUploadPhotoChatAllianceNotice(ret, resData, uploadPicVer, compressedPhotoPath)
  DataCenter.ChatSendPhotoManager:FinishedUploadPhotoChatAllianceNotice(ret, resData, uploadPicVer, compressedPhotoPath)
end

function CSharpCallLuaInterface.FinishSelectPhotoCommon(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
  DataCenter.SendPhotoToServerManager:OnSelectSingleImgFinish(selectedCompressedPhotoPath, compressedWidth, compressedHeight)
end

function CSharpCallLuaInterface.FinishSelectPhotoListCommon(selectedCompressedPhotoPathList, compressedWidthList, compressedHeightList)
  DataCenter.SendPhotoToServerManager:OnSelectImgListFinish(selectedCompressedPhotoPathList, compressedWidthList, compressedHeightList)
end

function CSharpCallLuaInterface.FinishedUploadPhotoCommon(ret, resData, uploadPicVer, compressedPhotoPath)
  DataCenter.SendPhotoToServerManager:FinishedUploadPhotoCommon(ret, resData, uploadPicVer, compressedPhotoPath)
end

function CSharpCallLuaInterface.FinishedUploadPhotoSeasonAlliance(ret, resData, uploadPicVer)
  DataCenter.SeasonPhotoManager:FinishedUploadPhotoSeasonAlliance(ret, resData, uploadPicVer)
end

function CSharpCallLuaInterface.GetRemarkOrRealName(uid, realName)
  return DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, realName)
end

function CSharpCallLuaInterface.DebugPlayTorchRelayBattle(levelId)
  DataCenter.LWBattleManager:DebugPlayTorchRelayBattle()
end

function CSharpCallLuaInterface.DebugOpenDominatorMain()
  DataCenter.LWGuideFlowManager.Runner:Run(5012)
end

function CSharpCallLuaInterface:IsUnlockEmojiInput()
  return ChatInterface.IsUnlockEmojiInput()
end

function CSharpCallLuaInterface:IsUnlockAt()
  return ChatInterface.IsAtOpen()
end

function CSharpCallLuaInterface:IsUnlockPredict()
  return true
end

local KeyList = {UseNewDeleteLogic = 1, RemoveComposeWhenInsert = 2}
local OpenStates = {
  [KeyList.UseNewDeleteLogic] = true,
  [KeyList.RemoveComposeWhenInsert] = true
}

function CSharpCallLuaInterface.GetFunctionFlags()
  local flags = 0
  for k, v in pairs(OpenStates) do
    if v then
      flags = flags | 1 << k
    end
  end
  return flags
end

function CSharpCallLuaInterface.RefreshBattleSoundMarch(march)
end

function CSharpCallLuaInterface.GetShowTroopLineMask()
  local mask = 7
  if not DisplaySettings then
    return mask
  end
  mask = DisplaySettings.GetShowTroopLineMask()
  return mask
end

function CSharpCallLuaInterface.GetShowTroopLineMidSprite()
  if not DisplaySettings then
    return true
  end
  return not DisplaySettings.HideTroopLineMiddleSprite()
end

function CSharpCallLuaInterface.GetCurrentDisplayLevel()
  if not DisplaySettings then
    return 0
  end
  return DisplaySettings.GetCurrentDisplayLevel()
end

function CSharpCallLuaInterface.DoCameraShake(duration, strength, vibrato)
  local _strength = Vector3.New(0.5, 0, 0.5) * strength
  duration = duration or 0.5
  vibrato = vibrato or 30
  ShakeUtil.DoCameraShakeKillExist({
    duration = duration,
    strength = strength,
    vibrato = vibrato
  })
end

function CSharpCallLuaInterface.DoMobileShake(intensity, sharpness, duration)
  ShakeUtil.DoVibration(intensity, sharpness, duration)
end

function CSharpCallLuaInterface.GetWerewolfMaxHp()
  return DataCenter.SeasonHunterManager:GetMaxHp()
end

function CSharpCallLuaInterface.IAmWerewolf()
  return DataCenter.SeasonHunterManager:IsInBattle()
end

function CSharpCallLuaInterface.GetTroopLineWidthScale()
  if not DisplaySettings then
    return 1
  end
  return DisplaySettings.GetTroopLineWidthScale()
end

function CSharpCallLuaInterface.GetTroopCircleScale()
  if not DisplaySettings then
    return 1
  end
  return DisplaySettings.GetTroopCircleScale()
end

function CSharpCallLuaInterface.ShowCountdownTimeUI(targetTimeMs, finalTxtId, lastTips)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityFightCountTimeToGo, {anim = true}, {
    protectTime = targetTimeMs,
    finalTxt = finalTxtId,
    lastTips = lastTips
  })
end

function CSharpCallLuaInterface.IsLittleSmartTroopEnable()
  if not DisplaySettings then
    return false
  end
  return DisplaySettings.IsLittleSmartTroopEnable()
end

function CSharpCallLuaInterface.IsLittleSmartTroopLineEnable()
  if not DisplaySettings then
    return false
  end
  return DisplaySettings.IsLittleSmartTroopLineEnable()
end

function CSharpCallLuaInterface.GetActivityAlarmClockShowServerTimeMode()
  return DataCenter.LWActivityAlarmClockManager:GetShowServerTimeMode()
end

function CSharpCallLuaInterface.RefreshPerformanceTroopCount(count)
  DisplaySettings.RefreshSquadCount(count)
end

function CSharpCallLuaInterface.RefreshPerformanceTroopLineCount(count)
end

function CSharpCallLuaInterface.RefreshPerformancePointCounts(objCount, dataCount)
end

function CSharpCallLuaInterface.GetLittleSmartTroopLineThreshold()
  return DisplaySettings and DisplaySettings.LittleSmartTroopLineThreshold or -1
end

function CSharpCallLuaInterface.CreateMonsterProtection(uuid)
  DataCenter.MonsterProtectionManager:CreateMonsterProtection(uuid)
end

function CSharpCallLuaInterface.RemoveMonsterProtection(uuid)
  DataCenter.MonsterProtectionManager:RemoveMonsterProtection(uuid)
end

function CSharpCallLuaInterface.GetBattleSoundConfig()
  return DataCenter.LWBattleSoundManager:GetConfig()
end

function CSharpCallLuaInterface.GetCityIdByPointIndex(pointId)
  local data = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(pointId)
  if data then
    return data.id
  end
  return 0
end

function CSharpCallLuaInterface.SetBattleSoundPlay(isPlay)
  DataCenter.LWBattleSoundManager:SetSoundPlay(isPlay)
end

function CSharpCallLuaInterface.GetGridData(row, col)
  local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
  local data = utils.GetGridData(row, col)
  if data and data.isBlock then
    return true
  end
  return false
end

function CSharpCallLuaInterface.GetMonsterTroopCreate(uuid)
  return DataCenter.RunningBossDataManager:GetMonsterTroopCreate(uuid)
end

function CSharpCallLuaInterface.OnRemoveMonsterTroopCreate(uuid)
  DataCenter.RunningBossDataManager:OnRemoveMonsterTroopCreate(uuid)
end

function CSharpCallLuaInterface.GetLuaLocalUTCOffset()
  return UITimeManager:GetInstance():GetLocalUTCOffset()
end

function CSharpCallLuaInterface.GetKingCityOccupiedRange()
  return DataCenter.BirthPointTemplateManager:GetKinCityOccupyRange()
end

function CSharpCallLuaInterface:GetCreditValue()
  return DataCenter.CreditManager:GetCreditValue() or 0
end

function CSharpCallLuaInterface.IsPlayerInSeasonOrHalt()
  return SeasonUtil.IsInSeasonOrHalt(LuaEntry.Player:GetCurServerId())
end

function CSharpCallLuaInterface.CreateZMBossActionCtrl(march, transform)
  if march then
    DataCenter.ZoneMobilizationCtrlManager:CreateBossActionCtrl(march, transform)
  end
end

function CSharpCallLuaInterface.RemoveZMBossActionCtrl(uuid)
  DataCenter.ZoneMobilizationCtrlManager:RemoveBossActionCtrl(uuid)
end

function CSharpCallLuaInterface.RefreshZMBossActionCtrl(march)
  DataCenter.ZoneMobilizationCtrlManager:RefreshBossActionCtrl(march)
end

function CSharpCallLuaInterface.CreateZMBuildingCtrl(uuid, transform)
  if uuid and transform then
    DataCenter.ZoneMobilizationCtrlManager:CreateBuildingCtrl(uuid, transform)
  end
end

function CSharpCallLuaInterface.RemoveZMBuildingCtrl(uuid)
  DataCenter.ZoneMobilizationCtrlManager:RemoveBuildingCtrl(uuid)
end

function CSharpCallLuaInterface.OnWorldPointInfoChanged(uuid)
  DataCenter.ZoneMobilizationCtrlManager:OnWorldPointInfoChanged(uuid)
end

function CSharpCallLuaInterface.GetCurRadarTreasureReceiveMultiValue(createTime)
  return MultiRewardDropUtils.GetCurRadarTreasureReceiveMultiValue(createTime)
end

function CSharpCallLuaInterface.CreateS0AllianceBossActionCtrl(march, transform)
  if march then
    DataCenter.S0AllianceBossCtrlManager:CreateBossActionCtrl(march, transform)
  end
end

function CSharpCallLuaInterface.RemoveS0AllianceBossActionCtrl(uuid)
  DataCenter.S0AllianceBossCtrlManager:RemoveBossActionCtrl(uuid)
end

function CSharpCallLuaInterface.RefreshS0AllianceBossActionCtrl(march)
  DataCenter.S0AllianceBossCtrlManager:RefreshBossActionCtrl(march)
end

function CSharpCallLuaInterface.CreateS0AllianceBossBuildingCtrl(uuid, transform)
  if uuid and transform then
    DataCenter.S0AllianceBossCtrlManager:CreateBuildingCtrl(uuid, transform)
  end
end

function CSharpCallLuaInterface.RemoveS0AllianceBossBuildingCtrl(uuid)
  DataCenter.S0AllianceBossCtrlManager:RemoveBuildingCtrl(uuid)
end

function CSharpCallLuaInterface.GetReloadValue()
  return RELOAD_VALUE
end

function CSharpCallLuaInterface.SetReloadValue(value)
  RELOAD_VALUE = value
end

function CSharpCallLuaInterface.IsBloodyNight(serverId)
  return DataCenter.BloodyNightDataManager:IsBloodyNight(serverId)
end

function CSharpCallLuaInterface.IsDawn(serverId)
  return DataCenter.BloodyNightDataManager:IsDawn(serverId)
end

function CSharpCallLuaInterface.GetMainBaseMaxLightLevel()
  local level = DataCenter.SeasonLightDataManager:GetMainBaseMaxLightLevel()
  return level
end

function CSharpCallLuaInterface.GetWeatherType()
  if not DataCenter.SeasonWeatherManager:IsOpen() then
    return SeasonWeatherType.Unknown
  end
  local weather = DataCenter.SeasonWeatherManager:GetWeatherInfo()
  if not weather then
    return SeasonWeatherType.Unknown
  end
  return DataCenter.SeasonWeatherManager:GetWeatherType(weather.weatherId)
end

function CSharpCallLuaInterface.GetWeatherMatPath(weatherType)
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  return typeInfo and typeInfo.fog_mat or ""
end

function CSharpCallLuaInterface.GetWeatherWorldFollowPath(weatherType)
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  return typeInfo and typeInfo.isFollow and typeInfo.world_assets or ""
end

function CSharpCallLuaInterface.GetWeatherCityColor(weatherType)
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  return typeInfo and typeInfo.city_color or Color.clear
end

function CSharpCallLuaInterface.GetWeatherCityFogColor(weatherType)
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  return typeInfo and typeInfo.city_fog_color or Color.clear
end

function CSharpCallLuaInterface.GetAllianceUnityConfigBySkillId(skillId)
  return DataCenter.AllianceSkillManager:GetAllianceUnityConfigBySkillId(skillId)
end

function CSharpCallLuaInterface.ResizePVEBulletCollider(size)
  return PvePhysicsUtil.ResizeBulletColliderResultArray(size)
end

function CSharpCallLuaInterface.ResizePVEMonsterCollider(size)
  return PvePhysicsUtil.ResizeMonsterColliderResultArray(size)
end

function CSharpCallLuaInterface.ResizePVEUnitCollider(size)
  return PvePhysicsUtil.ResizeUnitColliderResultArray(size)
end

function CSharpCallLuaInterface.ResizePVEPlayerCollider(size)
  return PvePhysicsUtil.ResizePlayerColliderResultArray(size)
end

function CSharpCallLuaInterface.ResizePVEObstacleCollider(size)
  return PvePhysicsUtil.ResizeObstacleColliderResultArray(size)
end

function CSharpCallLuaInterface.ResizePVEBulletView(size)
  local bulletViewUtil = require("Scene.LWBattle.Bullet.BulletViewUtil")
  return bulletViewUtil.ResizeBulletViewLuaArray(size)
end

function CSharpCallLuaInterface.GetHpBarCanvasTransform()
  local Layer = UIManager:GetInstance():GetLayer(UILayer.HpBar.Name)
  if Layer then
    local CanvasHpBar = Layer.gameObject
    if CanvasHpBar then
      return CanvasHpBar.transform
    end
  end
  return nil
end

function CSharpCallLuaInterface.UpdateWorldPointGameObject(uuid, transform)
  DataCenter.WorldPointProtectionManager:CreateProtection(uuid, transform)
  DataCenter.WorldPointWorkStateManager:Create(uuid, transform)
end

function CSharpCallLuaInterface.RemoveWorldPointGameObject(uuid)
  DataCenter.WorldPointProtectionManager:RemoveProtection(uuid)
  DataCenter.WorldPointWorkStateManager:Remove(uuid)
end

function CSharpCallLuaInterface.GetMobilSupportMultiple()
  return ChatInterface.GetMobilSupportMultiple()
end

function CSharpCallLuaInterface.GetMobilSupportChangeColor()
  return ChatInterface.GetMobilSupportChangeColor()
end

function CSharpCallLuaInterface.GetDynamicAtlasModelBlackList()
  return {
    "Google staryu",
    "Google kukui",
    "Redmi 2201116SC"
  }
end

function CSharpCallLuaInterface.CreateTroopZombieBusTrain(marchInfo, modelTrans)
  DataCenter.ZombieBusTrainEntityManager:CreateTroopZombieBusTrain(marchInfo, modelTrans)
end

function CSharpCallLuaInterface.RefreshTroopZombieBusTrain(marchInfo)
  DataCenter.ZombieBusTrainEntityManager:RefreshTroopZombieBusTrain(marchInfo)
end

function CSharpCallLuaInterface.DeleteTroopZombieBusTrain(uuid)
  DataCenter.ZombieBusTrainEntityManager:DeleteTroopZombieBusTrain(uuid)
end

function CSharpCallLuaInterface.GetCurWorldSeasonType()
  return SeasonUtil.GetCurWorldSeasonType(nil, false)
end

function CSharpCallLuaInterface.GetCurWorldSeasonSubType()
  return SeasonUtil.GetCurWorldSeasonType(nil, true)
end

function CSharpCallLuaInterface.GetSeasonStartTimeByServerId(serverId)
  return SeasonUtil.GetSeasonStartTimeByServerId(serverId)
end

function CSharpCallLuaInterface.GetStatusEndTime(statusId)
  return LuaEntry.Effect:GetStatusEndTime(statusId)
end

function CSharpCallLuaInterface.GetIfShowCheckNode(pointIndex)
  return DataCenter.ActEasterEggManager:GetHasSeenEgg(pointIndex)
end

function CSharpCallLuaInterface.CreateKillZombieKirovActionCtrl(march, transform)
  if march then
    DataCenter.KillZombieCtrlManager:CreateBossActionCtrl(march, transform)
  end
end

function CSharpCallLuaInterface.DelayRemoveKillZombieKirovActionCtrl(uuid, time)
  DataCenter.KillZombieCtrlManager:DelayRemoveKillZombieKirovActionCtrl(uuid, time)
end

function CSharpCallLuaInterface.RemoveKillZombieKirovActionCtrl(uuid)
  DataCenter.KillZombieCtrlManager:RemoveBossActionCtrl(uuid)
end

function CSharpCallLuaInterface.RefreshKillZombieKirovActionCtrl(march)
  DataCenter.KillZombieCtrlManager:RefreshBossActionCtrl(march)
end

function CSharpCallLuaInterface.GetDetectRetryTaskObjectPath(detectEventId)
  local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(detectEventId))
  return config:GetDetectRetryTaskObjectPath()
end

function CSharpCallLuaInterface.IsInFireworkQuickMode()
  return DataCenter.LWFireworkManager:IsInQuickMode()
end

function CSharpCallLuaInterface.UseFireworkItem(playerUid)
  DataCenter.LWFireworkManager:UseFireworkItem(playerUid)
end

function CSharpCallLuaInterface.UpdateFireworkList(playerUid, fireworkList)
  DataCenter.LWFireworkManager:UpdateFireworkQueueByUserUidCsData(playerUid, fireworkList)
end

function CSharpCallLuaInterface.UpdateFireworkGiftList(playerUid, fireworkGiftList, allianceUid)
  DataCenter.LWFireworkGiftManager:UpdateFireworkGiftQueueByUserUidCsData(playerUid, fireworkGiftList, allianceUid)
end

function CSharpCallLuaInterface.RefundPunishCanLogIn()
  return DataCenter.LWRefundPunishManager:GetCanLogIn()
end

function CSharpCallLuaInterface.GetQueenOfBloodCityIsDie(cityId)
  return DataCenter.OffSeason1QueenOfBloodManager:GetCityIsDie(cityId)
end

function CSharpCallLuaInterface.CreateWorldTroopLineQueen(uuid, startPos, endPos)
  DataCenter.WorldTroopLineQueenManager:CreateLine(uuid, startPos, endPos)
end

function CSharpCallLuaInterface.RemoveWorldTroopLineQueen(uuid)
  DataCenter.WorldTroopLineQueenManager:RemoveLine(uuid)
end

function CSharpCallLuaInterface.IsUnlockNewBattleReportDownloader()
  return true
end

function CSharpCallLuaInterface.GetAttackCityS0CityPointId(eventId)
  return DataCenter.AttackCityS0ConfigManager:GetCityPointIdByCityId(eventId)
end

function CSharpCallLuaInterface.IsSoundEffectGroup(name)
  return DataCenter.LWSoundManager:IsSoundEffectGroup(name)
end

function CSharpCallLuaInterface.IsEvnSoundEffectGroup(name)
  return DataCenter.LWSoundManager:IsEvnSoundEffectGroup(name)
end

function CSharpCallLuaInterface.GetAttackCityS0DetectInfo(pointId)
  return DataCenter.AttackCityS0DataManager:GetOneEventFeatureConfigId(pointId)
end

function CSharpCallLuaInterface.HaveAttackCityS0Radar(pointId)
  return DataCenter.AttackCityS0DataManager:HavePointIdRadar(pointId)
end

function CSharpCallLuaInterface.GetActGhostreconCanGet(serverId)
  return DataCenter.ActGhostreconManager:IsCanGetTheReward(serverId)
end

function CSharpCallLuaInterface.GetFlowerTrainLodIcon(marchUuid, index)
  return FlowerTrainUtils.GetFlowerTrainLodIcon(marchUuid, index)
end

function CSharpCallLuaInterface.SyncUseMixer(use)
  DataCenter.LWSoundManager:SyncUseAudioMixer(use)
end

function CSharpCallLuaInterface.DispatchTaskHasMarked(missionUuid)
  return DataCenter.ActDispatchTaskDataManager:HasMarked(missionUuid)
end

function CSharpCallLuaInterface.GetGearQuality()
  if GameQualitySettings.IsLowGearQuality() then
    return 2
  elseif GameQualitySettings.IsMidGearQuality() then
    return 1
  elseif GameQualitySettings.IsHighGearQuality() then
    return 0
  end
end

function CSharpCallLuaInterface.TimelineInteractionShowPlot(plotId)
  return DataCenter.TimelineInteractionManager:TryTimelineInteractionShowPlot(plotId)
end

function CSharpCallLuaInterface.TimelineInteractionShowQTE1(duration)
  return DataCenter.TimelineInteractionManager:TryTimelineInteractionShowQTE1(duration)
end

function CSharpCallLuaInterface.TimelineInteractionCloseQTE1()
  DataCenter.TimelineInteractionManager:TimelineInteractionCloseQTE1()
end

function CSharpCallLuaInterface.TimelineInteractionClosePlot()
  DataCenter.TimelineInteractionManager:TimelineInteractionClosePlot()
end

function CSharpCallLuaInterface.IsSceneCameraDisable()
  return UIManager:GetInstance():IsSceneCameraDisable()
end

function CSharpCallLuaInterface.PlaySound(id, isLoop)
  DataCenter.LWSoundManager:PlaySound(id, isLoop)
end

function CSharpCallLuaInterface.IsLandlordBattleStageAndWeekUnlock(cityId)
  return DataCenter.LandlordMgr:GetActCurStage() == LLConst.LandlordStage.BATTLE and DataCenter.LandlordMgr:IsUnlockCityByWeek(cityId)
end

function CSharpCallLuaInterface.IsLandlordInNewCenterMapPeriod()
  return DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
end

function CSharpCallLuaInterface.LLGetSelfCampId()
  return DataCenter.LandlordMgr:GetMyGroup()
end

function CSharpCallLuaInterface.IsLLOldBoomingCity(cityId)
  return DataCenter.LandlordMgr:IsOldCityBooming(cityId)
end

function CSharpCallLuaInterface.GetLLCurCityTableName()
  return DataCenter.LandlordMgr:GetCityTemplateTableName()
end

function CSharpCallLuaInterface.GetLLCityNextOpenTimeByCityId(cityId)
  return DataCenter.LandlordMgr:GetLLCityNextOpenTimeByCityId(cityId)
end

function CSharpCallLuaInterface.GetLLCurActEndTime()
  return DataCenter.LandlordMgr:GetLLCurActEndTime() * 1000
end

function CSharpCallLuaInterface.GetNearByCityId(cityId)
  DataCenter.AllianceCityTemplateManager:GetAllNearByCities(cityId)
end

function CSharpCallLuaInterface.OpenKR_RefundDetailMessage()
  UIUtil.ShowDetail(Localization:GetString("refund_policy_detail"), "refund_nonrefundable_button", nil, true, true)
end

function CSharpCallLuaInterface.DoCloseCustomerServiceRedPointData()
  DataCenter.LWCustomerServiceManager:DoCloseCustomerServiceRedPointData()
end

Logger.LogInfo("CSharpCallLuaInterface load finish")
return ConstClass("CSharpCallLuaInterface", CSharpCallLuaInterface)
