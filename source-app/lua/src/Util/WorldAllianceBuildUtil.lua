local WorldAllianceBuildUtil = {}

local function GetBuildTileList(buildId, index)
  local res = {}
  local sz = 0
  local tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if tempTemplate then
    sz = toInt(tempTemplate.resSize)
  end
  if sz ~= nil and 1 < sz then
    local vecPos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
    local radius = math.ceil((sz - 1) / 2)
    local item
    for x = vecPos.x - radius, vecPos.x + radius do
      for y = vecPos.y - radius, vecPos.y + radius do
        item = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
        table.insert(res, item)
      end
    end
  else
    table.insert(res, index)
  end
  return res
end

local function GetBuildTileIndex(buildId, index, buildTopType)
  local res = {}
  local sz = 0
  local tempTemplate
  if buildTopType == PlaceBuildType.CityAttachment then
    tempTemplate = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(buildId)
    if tempTemplate then
      sz = toInt(tempTemplate.size_x or tempTemplate.size_y)
    end
  else
    tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
    if tempTemplate then
      sz = toInt(tempTemplate.resSize)
    end
  end
  if sz ~= nil and 1 < sz then
    local vecPos = {x = 0, y = 0}
    if index ~= -1 and index ~= 0 then
      vecPos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
    end
    local rangeList = BuildingUtils.GetAllNeighborsPos4(vecPos, sz, sz)
    if rangeList ~= nil and 0 < #rangeList then
      table.walk(rangeList, function(k, v)
        local item = SceneUtils.TilePosToIndex(v, ForceChangeScene.World)
        table.insert(res, item)
      end)
    end
  else
    table.insert(res, index)
  end
  return res
end

function WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId)
  if buildId == nil or buildId == 0 or toInt(buildId) < 1000 then
    return false
  end
  if buildId == BuildingTypes.ALLIANCE_CENTER_1 or buildId == BuildingTypes.ALLIANCE_CENTER_2 or buildId == BuildingTypes.ALLIANCE_CENTER_3 or buildId == BuildingTypes.ALLIANCE_CENTER_4 then
    return true
  end
  local config = LocalController:instance():tryGetLine(TableName.AllianceMine, buildId)
  if config and (config.type == AllianceBuildType.StoveCenter or config.type == AllianceBuildType.MilitaryCenter or config.type == AllianceBuildType.MilitaryCenterS4 or config.type == AllianceBuildType.Center) then
    return true
  end
  if config and config.model == "allianceBuilding_center" then
    return true
  end
  return false
end

function WorldAllianceBuildUtil.IsAllianceCenterCarrierGroup(buildId)
  if buildId == nil or buildId == 0 or toInt(buildId) < 1000 then
    return false
  end
  local config = LocalController:instance():tryGetLine(TableName.AllianceMine, buildId)
  if config and config.type == AllianceBuildType.Carrier then
    return true
  end
  return false
end

function WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId)
  if buildId == nil or buildId == 0 or toInt(buildId) < 1000 then
    return false
  end
  if buildId == BuildingTypes.ALLIANCE_FLAG_BUILD1 or buildId == BuildingTypes.ALLIANCE_FLAG_BUILD2 or buildId == BuildingTypes.ALLIANCE_FLAG_BUILD3 or buildId == BuildingTypes.ALLIANCE_FLAG_BUILD4 or buildId == BuildingTypes.ALLIANCE_FLAG_BUILD5 then
    return true
  end
  local config = LocalController:instance():tryGetLine(TableName.AllianceMine, buildId)
  if config and config.type == AllianceBuildType.Outpost then
    return true
  end
  if config and config.model == "allianceBuilding_flag" then
    return true
  end
  return false
end

local function IsAllianceFrontGroup(buildId)
  if buildId == BuildingTypes.ALLIANCE_FRONT_BUILD_1 or buildId == BuildingTypes.ALLIANCE_FRONT_BUILD_2 or buildId == BuildingTypes.ALLIANCE_FRONT_BUILD_3 then
    return true
  end
  return false
end

local function IsAllianceMineGroup(buildId)
  if buildId == BuildingTypes.ALLIANCE_RES_1 or buildId == BuildingTypes.ALLIANCE_RES_2 or buildId == BuildingTypes.ALLIANCE_RES_3 or buildId == BuildingTypes.ALLIANCE_RES_4 or buildId == BuildingTypes.ALLIANCE_RES_5 or buildId == BuildingTypes.ALLIANCE_RES_6 or buildId == BuildingTypes.ALLIANCE_RES_7 or buildId == BuildingTypes.ALLIANCE_RES_8 or buildId == BuildingTypes.ALLIANCE_RES_9 then
    return true
  end
  return false
end

local function IsAllianceActMineGroup(buildId)
  if buildId == BuildingTypes.ALLIANCE_ACT_RES_1 or buildId == BuildingTypes.ALLIANCE_ACT_RES_2 or buildId == BuildingTypes.ALLIANCE_ACT_RES_3 then
    return true
  end
  if buildId == BuildingTypes.EDEN_ALLIANCE_ACT_RES_1 or buildId == BuildingTypes.EDEN_ALLIANCE_ACT_RES_2 or buildId == BuildingTypes.EDEN_ALLIANCE_ACT_RES_3 then
    return true
  end
  return false
end

local function IsAllianceS0DeclareBuild(buildId)
  if buildId == BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    return true
  end
  return false
end

local function IsCanPutDownByAllianceBuild(buildId, index, theServerId)
  if buildId == BuildingTypes.SEASON_ARES_MISSILE or buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 then
    local seasonType = SeasonUtil.GetSeasonType()
    local vecPos2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World, theServerId)
    local vecPos3 = SceneUtils.IndexToTilePos(DataCenter.AllianceGovernmentSkillManager:GetAresMissileSkillTargetIndex(), ForceChangeScene.World, theServerId)
    local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
    if mainBuildId ~= 0 and seasonType ~= SeasonMapType.CityStronghold then
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(mainBuildId)
      if meta then
        local offer_range = meta.offter_range
        if 0 < offer_range and (offer_range < math.abs(vecPos2.x - vecPos3.x) or offer_range < math.abs(vecPos2.y - vecPos3.y)) then
          return BuildPutState.NoInAllianceCenterRange
        end
      end
    end
    return BuildPutState.Ok
  elseif buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL then
    local curServerId = theServerId or LuaEntry.Player:GetCurServerId()
    local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
    local cityId = SceneUtils.GetZoneIdByPosId(index)
    if cityId ~= kingCityId then
      return BuildPutState.OutBuildZone
    end
    return BuildPutState.Ok
  elseif buildId == BuildingTypes.CAMP_SEASON_MISSILE then
    local curServerId = LuaEntry.Player:GetSelfServerId()
    local isSampGroup = SeasonUtil.IsInSameGroup(curServerId, ServerEnum.Source)
    if curServerId ~= theServerId or not isSampGroup then
      return BuildPutState.OutBuildZone
    else
      local vecPos2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World, curServerId)
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
      local offer_range = (meta.resSize - 1) / 2
      local aVectorPos2 = {
        x = offer_range + vecPos2.x,
        y = offer_range + vecPos2.y
      }
      local bVectorPos2 = {
        x = -offer_range + vecPos2.x,
        y = -offer_range + vecPos2.y
      }
      local cVectorPos2 = {
        x = -offer_range + vecPos2.x,
        y = offer_range + vecPos2.y
      }
      local dVectorPos2 = {
        x = offer_range + vecPos2.x,
        y = -offer_range + vecPos2.y
      }
      local aWorldPos = SceneUtils.TileToWorld(aVectorPos2, ForceChangeScene.World, curServerId)
      local bWorldPos = SceneUtils.TileToWorld(bVectorPos2, ForceChangeScene.World, curServerId)
      local cWorldPos = SceneUtils.TileToWorld(cVectorPos2, ForceChangeScene.World, curServerId)
      local dWorldPos = SceneUtils.TileToWorld(dVectorPos2, ForceChangeScene.World, curServerId)
      local worldPoss = {
        aWorldPos,
        bWorldPos,
        cWorldPos,
        dWorldPos
      }
      local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
      local inS5BigMap = SeasonUtil.InSeasonBigMapMode(curServerId)
      if inS5BigMap and seasonInfo then
        for _, v in ipairs(worldPoss) do
          local mapIndex = seasonInfo:GetNinePalacesIndexByWorldPos(v)
          local serverId = seasonInfo:GetNinePalacesServer(mapIndex)
          if serverId ~= curServerId then
            return BuildPutState.OutBuildZone
          end
        end
      end
    end
    return BuildPutState.Ok
  elseif buildId == BuildingTypes.CAMP_Reinforcement then
    local curServerId = LuaEntry.Player:GetSelfServerId()
    local isSampGroup = SeasonUtil.IsInSameGroup(theServerId, ServerEnum.Source)
    if curServerId ~= theServerId or not isSampGroup then
      return BuildPutState.OutBuildZone
    end
    local vecPos2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World, theServerId)
    local theWorld = CS.SceneManager.World
    if theWorld ~= nil then
      local allianceCityList = theWorld:GetAllAllianceCityList()
      for index = 0, allianceCityList.Count - 1 do
        local pointInfo = allianceCityList[index]
        local cityId = pointInfo.CityInfo.CityId
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, theServerId)
        if cityMeta and cityMeta:IsCity() then
          local isMyCamp = DataCenter.WorldAllianceCityDataManager:IsMyCamp(theServerId, pointInfo.CityInfo.CityId)
          local vecPos3 = SceneUtils.IndexToTilePos(pointInfo.mainIndex, ForceChangeScene.World, theServerId)
          if isMyCamp then
            local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
            local offer_range = (meta.resSize - 1) / 2
            if offer_range > math.abs(vecPos2.x - vecPos3.x) and offer_range > math.abs(vecPos2.y - vecPos3.y) then
              return BuildPutState.Ok
            end
          end
        end
      end
    end
    return BuildPutState.OutBuildZone
  elseif buildId == BuildingTypes.GODDESS_MUMMY_TARGET then
    return BuildPutState.Ok
  elseif buildId == BuildingTypes.CAMP_GODDESS_MUMMY_TARGET then
    local curServerId = LuaEntry.Player:GetSelfServerId()
    local isSampGroup = SeasonUtil.IsInSameGroup(curServerId, ServerEnum.Source)
    if curServerId ~= theServerId or not isSampGroup then
      return BuildPutState.OutBuildZone
    end
    return BuildPutState.Ok
  end
  local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
  if buildId == mainBuildId or buildId == carrierBuildId then
    return WorldAllianceBuildUtil.IsCanPutDownByStoveCenter(buildId, index)
  end
  if WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) == true then
    return WorldAllianceBuildUtil.IsCanPutDownByAllianceCenter(buildId, index)
  end
  if WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) == true then
    return WorldAllianceBuildUtil.IsCanPutDownByAllianceCenter(buildId, index)
  end
  local points = WorldAllianceBuildUtil.GetBuildTileIndex(buildId, index)
  local isCanPlaceInMain = true
  if WorldAllianceBuildUtil.IsAllianceMineGroup(buildId) == true and buildId and LuaEntry.Player.serverType == ServerType.NORMAL then
    local tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
    if tempTemplate ~= nil and 0 < tempTemplate.limitRuin then
      isCanPlaceInMain = false
    end
  end
  for k, v in pairs(points) do
    local putState = WorldAllianceBuildUtil.IsCanPutDownByPoint(v, buildId, isCanPlaceInMain, theServerId)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

local function IsCanPutDownByStoveCenter(buildId, index)
  local points = WorldAllianceBuildUtil.GetBuildTileList(buildId, index)
  local tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if tempTemplate ~= nil then
    local zoneId = SceneUtils.GetZoneIdByPosId(index)
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId, LuaEntry.Player:GetCurServerId())
    if not cityMeta then
      return BuildPutState.ZoneLevelNotEnough
    end
    local cityLv = cityMeta.level
    if SeasonUtil.IsInSeasonCityStrongholdMode() or SeasonUtil.IsInSeasonSnowMode() or SeasonUtil.IsInSeasonMummyMode() or SeasonUtil.IsInSeasonDarknessMode() then
      if cityLv > tempTemplate.level then
        return BuildPutState.ZoneTypeOrLevelNotMatch
      end
    elseif cityLv ~= tempTemplate.level then
      return BuildPutState.ZoneLevelNotEnough
    end
  end
  for k, v in pairs(points) do
    local putState = WorldAllianceBuildUtil.IsCanPutDownAllianceCenterByPoint(v)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

local function IsCanPutDownByAllianceCenter(buildId, index)
  if index == nil or index == 0 then
    return BuildPutState.OutBuildZone
  end
  local points = WorldAllianceBuildUtil.GetBuildTileIndex(buildId, index)
  local tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if tempTemplate ~= nil then
    local zoneId = SceneUtils.GetZoneIdByPosId(index)
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId, LuaEntry.Player:GetCurServerId())
    local cityLv = cityMeta.level
    if SeasonUtil.IsInSeasonCityStrongholdMode() or SeasonUtil.IsInSeasonSnowMode() or SeasonUtil.IsInSeasonMummyMode() or SeasonUtil.IsInSeasonDarknessMode() then
      if cityMeta.type ~= 4 or cityLv > tempTemplate.level then
        return BuildPutState.ZoneTypeOrLevelNotMatch
      end
    elseif cityLv ~= tempTemplate.level then
      return BuildPutState.ZoneLevelNotEnough
    end
  end
  for k, v in pairs(points) do
    local putState = WorldAllianceBuildUtil.IsCanPutDownAllianceCenterByPoint(v)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

local function IsCanPutDownAllianceCenterByPoint(index)
  if not SceneUtils.IsIndexInWorld(index) then
    return BuildPutState.StaticPoint
  end
  if CS.SceneManager.World:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if SceneUtils.IsInBlackRange(index) then
    return BuildPutState.InBlackLandRange
  end
  if DataCenter.BirthPointTemplateManager:IsInAllianceCityRange(index) then
    return BuildPutState.Building
  end
  if DataCenter.BirthPointTemplateManager:IsInAllianceCityField(index) then
    return BuildPutState.Building
  end
  if DataCenter.DesertDataManager:CanPlaceAllianceCenterByPointId(index) == false then
    return BuildPutState.InOtherBaseRange
  end
  if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
    local myAllow = false
    local areaId = CS.SceneManager.World:GetAreaIdByPosId(index - 1)
    local areaTemp = DataCenter.EdenAreaTemplateManager:GetTemplate(areaId)
    if areaTemp ~= nil then
      if areaTemp.area_type == EdenAreaType.NORTH_BORN_AREA then
        if DataCenter.RobotWarsManager:GetSelfCamp() == EdenCamp.NORTH then
          myAllow = true
        end
      elseif areaTemp.area_type == EdenAreaType.SOUTH_BORN_AREA and DataCenter.RobotWarsManager:GetSelfCamp() == EdenCamp.SOUTH then
        myAllow = true
      end
    end
    if myAllow == false then
      return BuildPutState.AllianceBuildNotInBirthRange
    end
  end
  local temp = CS.SceneManager.World:GetPointInfo(index)
  if temp ~= nil then
    return BuildPutState.Building
  end
  local worldPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World)
  if CS.SceneManager.World:IsTileWalkable(worldPos) == false then
    return BuildPutState.StaticPoint
  end
  return BuildPutState.Ok
end

local function IsCanPutDownByPoint(index, buildId, isCanPlaceInMain, theServerId)
  if CS.SceneManager.World:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if SceneUtils.IsInBlackRange(index) then
    return BuildPutState.InBlackLandRange
  end
  if WorldAllianceBuildUtil.IsAllianceMineGroup(buildId) == true then
    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
      local myAllow = false
      local areaId = CS.SceneManager.World:GetAreaIdByPosId(index - 1)
      local areaTemp = DataCenter.EdenAreaTemplateManager:GetTemplate(areaId)
      if areaTemp ~= nil then
        if areaTemp.area_type == EdenAreaType.NORTH_BORN_AREA then
          if DataCenter.RobotWarsManager:GetSelfCamp() == EdenCamp.NORTH then
            myAllow = true
          end
        elseif areaTemp.area_type == EdenAreaType.SOUTH_BORN_AREA and DataCenter.RobotWarsManager:GetSelfCamp() == EdenCamp.SOUTH then
          myAllow = true
        end
      end
      if myAllow == false then
        return BuildPutState.AllianceMineNotInBirthRange
      end
    end
    local zoneId = SceneUtils.GetZoneIdByPosId(index)
    local cityInfo
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(zoneId)
    if cityData ~= nil and cityData.allianceId ~= nil and cityData.allianceId ~= "" and cityData.allianceId == LuaEntry.Player.allianceId then
      cityInfo = cityData
    end
    if cityInfo ~= nil then
      local v2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
      local distanceMax = LuaEntry.DataConfig:TryGetNum("allance_build", "k1")
      local size = GetTableData(TableName.WorldCity, zoneId, "size")
      local min = math.ceil(size / 2)
      local max = math.floor(distanceMax / 2)
      local centerV2 = cityInfo.posV2
      local distanceX = math.abs(v2.x - centerV2.x)
      local distanceY = math.abs(v2.y - centerV2.y)
      if min >= distanceX and min >= distanceY then
        return BuildPutState.Building
      elseif max <= distanceX or max <= distanceY then
        if isCanPlaceInMain then
          local k2 = LuaEntry.DataConfig:TryGetNum("allance_build", "k2")
          local maxMainRange = math.floor(k2 / 2)
          local mainV2 = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
          local dX = math.abs(v2.x - mainV2.x)
          local dY = math.abs(v2.y - mainV2.y)
          if maxMainRange <= dX or maxMainRange <= dY then
            return BuildPutState.NotNearAlRuin
          end
        else
          return BuildPutState.NotNearAlRuin
        end
      end
    elseif isCanPlaceInMain then
      local v2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
      local k2 = LuaEntry.DataConfig:TryGetNum("allance_build", "k2")
      local maxMainRange = math.floor(k2 / 2)
      local mainV2 = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
      local dX = math.abs(v2.x - mainV2.x)
      local dY = math.abs(v2.y - mainV2.y)
      if maxMainRange <= dX or maxMainRange <= dY then
        return BuildPutState.NotNearAlRuin
      end
    else
      return BuildPutState.NotNearAlRuin
    end
  end
  if DataCenter.DesertDataManager:CanPlaceAllianceBuildByPointId(index) == false then
    return BuildPutState.OnLandLock
  end
  local temp = CS.SceneManager.World:GetPointInfo(index)
  if temp ~= nil then
    return BuildPutState.Building
  end
  local worldPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, theServerId)
  if CS.SceneManager.World:IsTileWalkable(worldPos) == false then
    return BuildPutState.StaticPoint
  end
  return BuildPutState.Ok
end

local function GetKingDomeShellEffPath()
  local isNbServer = DataCenter.ActMigrationManager:IsNBServer()
  return isNbServer and UIAssets.LWCityDomeHudunMigrationEffect or UIAssets.LWKingDomeHudunEffect
end

local function GetCityShellEffPath()
  local isNbServer = DataCenter.ActMigrationManager:IsNBServer()
  return isNbServer and UIAssets.LWCityDomeHudunMigrationEffect or UIAssets.LWCityDomeHudunEffect
end

WorldAllianceBuildUtil.IsCanPutDownByAllianceBuild = IsCanPutDownByAllianceBuild
WorldAllianceBuildUtil.IsCanPutDownByPoint = IsCanPutDownByPoint
WorldAllianceBuildUtil.GetBuildTileIndex = GetBuildTileIndex
WorldAllianceBuildUtil.IsAllianceMineGroup = IsAllianceMineGroup
WorldAllianceBuildUtil.IsCanPutDownByAllianceCenter = IsCanPutDownByAllianceCenter
WorldAllianceBuildUtil.IsCanPutDownAllianceCenterByPoint = IsCanPutDownAllianceCenterByPoint
WorldAllianceBuildUtil.IsAllianceFrontGroup = IsAllianceFrontGroup
WorldAllianceBuildUtil.IsAllianceActMineGroup = IsAllianceActMineGroup
WorldAllianceBuildUtil.IsAllianceS0DeclareBuild = IsAllianceS0DeclareBuild
WorldAllianceBuildUtil.IsCanPutDownByStoveCenter = IsCanPutDownByStoveCenter
WorldAllianceBuildUtil.GetBuildTileList = GetBuildTileList
WorldAllianceBuildUtil.GetKingDomeShellEffPath = GetKingDomeShellEffPath
WorldAllianceBuildUtil.GetCityShellEffPath = GetCityShellEffPath
return ConstClass("BuildingUtils", WorldAllianceBuildUtil)
