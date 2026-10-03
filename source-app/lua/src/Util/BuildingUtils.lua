local BuildingUtils = {}
local RocketType = typeof(CS.BaseRocketCenter)
local seasonFarm = {
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_1,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_2,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_3,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4,
  BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_5
}
local season2Farm = {
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_1,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_2,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_3,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_4,
  BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5
}
local season3Farm = {
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_1,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_2,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_3,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_4,
  BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5
}
local season4Farm = {
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY1,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY2,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY3,
  BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY4,
  BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD
}
local season5Farm = {
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_1,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_2,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_3,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_4,
  BuildingTypes.LW_BUILDING_SEASON5_CTIY_5
}
local season6Farm = {
  BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY1,
  BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY2,
  BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY3,
  BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY4,
  BuildingTypes.LW_BUILD_SEASON6_WEEK_CARD
}
local BuildingDataMac = {
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_1] = seasonFarm,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_2] = seasonFarm,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_3] = seasonFarm,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4] = seasonFarm,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_5] = seasonFarm,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_1] = season2Farm,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_2] = season2Farm,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_3] = season2Farm,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_4] = season2Farm,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5] = season2Farm,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_1] = season5Farm,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_2] = season5Farm,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_3] = season5Farm,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_4] = season5Farm,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_5] = season5Farm,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY1] = season6Farm,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY2] = season6Farm,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY3] = season6Farm,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY4] = season6Farm,
  [BuildingTypes.LW_BUILD_SEASON6_WEEK_CARD] = season6Farm,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_1] = season3Farm,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_2] = season3Farm,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_3] = season3Farm,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_4] = season3Farm,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5] = season3Farm,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY1] = season4Farm,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY2] = season4Farm,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY3] = season4Farm,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY4] = season4Farm,
  [BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD] = season4Farm
}

local function GetTrainingTypeAndBuildingType(buildId)
  if buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    return NewQueueType.FootSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    return NewQueueType.BowSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    return NewQueueType.CarSoldier
  end
  return NewQueueType.Default
end

local function GetMainPos()
  return DataCenter.BuildManager.main_city_pos
end

local function GetAllNeighborsPosCenter(pos, tileX, tileY)
  local result = {}
  local halfX = tileX // 2
  local halfY = tileY // 2
  for i = -halfX, halfX do
    for j = -halfY, halfY do
      local item = {}
      item.x = pos.x + i
      item.y = pos.y + j
      table.insert(result, item)
    end
  end
  return result
end

local function GetAllNeighborsPos4(pos, tileX, tileY)
  local result = {}
  if tileY == nil and tileX ~= nil then
    tileY = tileX
  end
  for i = 1, tileX do
    for y = 1, tileY do
      local item = {}
      item.x = pos.x - i + 1
      item.y = pos.y - y + 1
      table.insert(result, item)
    end
  end
  return result
end

local function GetAllNeighborsPos(pos, tileX, tileY)
  local newPos = {}
  if tileY == nil and tileX ~= nil then
    tileY = tileX
  end
  newPos.x = pos.x + tileX - 1
  newPos.y = pos.y + tileY - 1
  local list = BuildingUtils.GetAllNeighborsPos4(newPos, 2 * tileX - 1, 2 * tileY - 1)
  if list ~= nil and 0 < #list then
    table.removebyvalue(list, pos)
  end
  return list
end

local function GetBuildRoundPos(pos, tileX, tileY)
  if tileY == nil and tileX ~= nil then
    tileY = tileX
  end
  local result = {}
  local xOffset = (tileX + 1) * 0.5
  local yOffset = (tileY + 1) * 0.5
  local xMin = pos.x - xOffset
  local yMin = pos.y - yOffset
  local xMax = pos.x + xOffset
  local yMax = pos.y + yOffset
  for x = xMin, xMax do
    for y = yMin, yMax do
      if x == xMin or x == xMax or y == yMin or y == yMax then
        table.insert(result, {x = x, y = y})
      end
    end
  end
  return result
end

local function GetBuildTileIndex(buildId, index)
  local res = {}
  local tileX = 0
  local tileY = 0
  local vecPos = {x = 0, y = 0}
  if index ~= -1 and index ~= 0 then
    vecPos = SceneUtils.IndexToTilePos(index)
  end
  if SceneUtils.GetIsInWorld() and buildId == BuildingTypes.FUN_BUILD_MAIN then
    tileX = LuaEntry.DataConfig:TryGetNum("worldmap_city", "k12")
    tileY = tileX
    vecPos.x = vecPos.x + (tileX - 1) / 2
    vecPos.y = vecPos.y + (tileY - 1) / 2
  else
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if template ~= nil then
      tileX = template.tileX
      tileY = template.tileY
    end
  end
  if 1 < tileX or 1 < tileY then
    local rangeList = BuildingUtils.GetAllNeighborsPos4(vecPos, tileX, tileY)
    if rangeList ~= nil and 0 < #rangeList then
      table.walk(rangeList, function(k, v)
        local item = SceneUtils.TilePosToIndex(v)
        table.insert(res, item)
      end)
    end
  else
    table.insert(res, index)
  end
  return res
end

local function IsCanPutDownByBuild(buildId, index, buildUuid, noPutPoint, theServerId)
  if index == nil or index == 0 then
    return BuildPutState.MoveCityNotInUnLockRange
  end
  local isInSeason = SeasonUtil.IsInSeasonOrHalt(theServerId or LuaEntry.Player:GetCurServerId())
  local theWorld = CS.SceneManager.World
  if SceneUtils.GetIsInWorld() and isInSeason and buildId ~= BuildingTypes.FUN_BUILD_MAIN and buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB and buildId ~= BuildingTypes.WORM_HOLE_CROSS then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil and buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
      local mainIndex = index
      local allianceCenterBaseId = buildTemplate.allianceCenterBaseId
      local canPlace = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(mainIndex, allianceCenterBaseId)
      if not canPlace then
        return BuildPutState.NoInAllianceCenterRange
      end
      local worldTileInfo = theWorld:GetWorldTileInfo(mainIndex)
      if worldTileInfo ~= nil then
        local desertInfo = worldTileInfo:GetWorldDesertInfo()
        if desertInfo ~= nil then
          local playerType = desertInfo:GetPlayerType()
          if playerType == CS.PlayerType.PlayerNone or playerType == CS.PlayerType.PlayerSelf or playerType == CS.PlayerType.PlayerAlliance or playerType == CS.PlayerType.PlayerAllianceLeader then
            local desert_level = GetTableData(TableName.Desert, desertInfo.desertId, "desert_level")
            if desert_level and 0 < toInt(desert_level) then
              return BuildPutState.NotEmptyOrNotSelfAlliance
            end
          else
            return BuildPutState.NotEmptyOrNotSelfAlliance
          end
        end
      end
      local vecPos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
      local rangeList = BuildingUtils.GetBuildRoundPos(vecPos, buildTemplate.tileX, buildTemplate.tileY)
      local alreadyExitOccupy = false
      for i = 1, #rangeList do
        if alreadyExitOccupy == false then
          local v2 = rangeList[i]
          alreadyExitOccupy = SeasonUtil.IsDesertOccupy(SceneUtils.TilePosToIndex(v2, ForceChangeScene.World))
        else
          break
        end
      end
      if alreadyExitOccupy == false then
        return BuildPutState.NotConnectDesert
      end
    end
  end
  local resourceType = DataCenter.BuildManager:GetResourceTypeByBuildId(buildId)
  local points = BuildingUtils.GetBuildTileIndex(buildId, index)
  local isHaveCollect = false
  for k, v in pairs(points) do
    ProfilerUtil.BeginSample("BuildingUtils.IsCanPutDownByPoint")
    local putState = BuildingUtils.IsCanPutDownByPoint(v, buildId, buildUuid, resourceType, noPutPoint, true, theWorld, isInSeason, theServerId)
    ProfilerUtil.EndSample()
    if putState == BuildPutState.Ok then
      isHaveCollect = true
    elseif putState ~= BuildPutState.NoCollectRange then
      return putState
    end
  end
  if resourceType ~= ResourceType.None and isHaveCollect == false then
    return BuildPutState.NoCollectRange
  end
  local marchState = BuildingUtils.CanPutDownWithMarch(points)
  if marchState ~= BuildPutState.Ok then
    return marchState
  end
  return BuildPutState.Ok
end

local function GetSeasonBuildingGroupByType(buildId)
  local result = {}
  if not SeasonUtil.IsSeasonWeekCardBuilding(buildId) and not SeasonUtil.IsSeasonFarmBuilding(buildId) then
    return result
  end
  local mgr = DataCenter.BuildManager
  local config = SeasonUtil.GetSeasonWeekCardConfig()
  if config ~= nil then
    local farm_building = config.farm_building
    local farm_building_weekcard = toInt(config.farm_building_weekcard)
    if 0 < farm_building_weekcard and farm_building ~= nil and type(farm_building) == "string" then
      local arr = string.split_ii_array(farm_building, "|")
      for _, theBuildId in ipairs(arr) do
        local ret = mgr:GetAllBuildingByItemIdWithoutPickUp(theBuildId)
        if ret then
          for _, v in pairs(ret) do
            table.insert(result, v)
          end
        end
      end
      local ret = mgr:GetAllBuildingByItemIdWithoutPickUp(farm_building_weekcard)
      if ret then
        for _, v in pairs(ret) do
          table.insert(result, v)
        end
      end
      return result
    end
  end
  if BuildingDataMac[buildId] then
    for key, value in pairs(BuildingDataMac[buildId]) do
      local ret = mgr:GetAllBuildingByItemIdWithoutPickUp(value)
      if ret then
        for _, v in pairs(ret) do
          table.insert(result, v)
        end
      end
    end
  end
  return result
end

local SeasonCityBuildingMap = {
  [BuildingTypes.LW_BUILDING_SEASON_VIRUS_INSTITUTE_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_1] = true,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_2] = true,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_3] = true,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4] = true,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_5] = true,
  [BuildingTypes.LW_BUILDING_SEASON_TANK_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON_PLANE_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON_MISSILE_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_1] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_2] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_3] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_4] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_TANK_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_PLANE_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON2_MISSILE_CTIY] = true,
  [BuildingTypes.LW_BUILDING_CURSE_RESEARCH] = true,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_1] = true,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_2] = true,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_3] = true,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_4] = true,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5] = true,
  [BuildingTypes.LW_BUILD_ALTAR_MUMMY] = true,
  [BuildingTypes.LW_BUILD_SEASON_BIG_PHOTO] = true,
  [BuildingTypes.LW_BUILD_SEASON4_INSTITUTE] = true,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY1] = true,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY2] = true,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY3] = true,
  [BuildingTypes.LW_BUILD_SEASON4_QUARTZ_FACTORY4] = true,
  [BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD] = true,
  [BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE] = true,
  [BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1] = true,
  [BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2] = true,
  [BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3] = true,
  [BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4] = true,
  [BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S5] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_RESEARCH] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_1] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_2] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_3] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_4] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_5] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_SHOP] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_TANK_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_PLANE_CTIY] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_MISSILE_CTIY] = true,
  [BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S6] = true,
  [BuildingTypes.LW_BUILD_SEASON6_INSTITUTE] = true,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY1] = true,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY2] = true,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY3] = true,
  [BuildingTypes.LW_BUILD_SEASON6_QUARTZ_FACTORY4] = true,
  [BuildingTypes.LW_BUILD_SEASON6_WEEK_CARD] = true,
  [BuildingTypes.LW_BUILD_SEASON6_BUILD1] = true,
  [BuildingTypes.LW_BUILD_SEASON6_BUILD2] = true,
  [BuildingTypes.LW_BUILD_SEASON6_BUILD3] = true,
  [BuildingTypes.LW_BUILD_SEASON6_BUILD4] = true
}
local SeasonWeekCardCityBuildingMap = {
  [BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5] = true,
  [BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5] = true,
  [BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4] = true,
  [BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD] = true,
  [BuildingTypes.LW_BUILDING_SEASON5_CTIY_5] = true,
  [BuildingTypes.LW_BUILD_SEASON6_WEEK_CARD] = true
}

function BuildingUtils.GetSeasonWeekCardCityBuildingMap()
  local buildId = 0
  local config = SeasonUtil.GetSeasonWeekCardConfig()
  if config ~= nil then
    buildId = toInt(config.farm_building_weekcard)
  end
  if 0 < buildId then
    SeasonWeekCardCityBuildingMap[buildId] = true
  end
  return SeasonWeekCardCityBuildingMap
end

local function IsSeasonWeekCardCityBuilding(buildId)
  if SeasonWeekCardCityBuildingMap[buildId] then
    return true
  end
  if SeasonUtil.IsSeasonWeekCardBuilding(buildId) then
    return true
  end
  return false
end

local function IsSeasonInCityBuilding(buildId)
  if SeasonUtil.IsSeasonWeekCardBuilding(buildId) or SeasonUtil.IsSeasonFarmBuilding(buildId) then
    return true
  end
  if SeasonCityBuildingMap[buildId] then
    return true
  end
  return false
end

local function CheckIgnoreRangeLimit(buildId)
  if IsSeasonInCityBuilding(buildId) then
    return true
  end
  return false
end

local function IsCanPutDownByPoint(index, buildId, buildUuid, resType, noPutPoint, withOutMarch, theWorld, isInSeason, theServerId)
  if noPutPoint ~= nil and noPutPoint[index] ~= nil then
    return BuildPutState.Building
  end
  if theWorld == nil then
    theWorld = CS.SceneManager.World
  end
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if template ~= nil then
    local isSecBuild = template.build_type == BuildType.Second
    if isSecBuild and BuildingUtils.IsInMainSubRange(index, template.sup_main_build_id) == false then
      return BuildPutState.OutMainSubRange
    end
    if (template.zoneType == nil or template.zoneType == 0) and theWorld:IsInMapByIndex(index) == false then
      return BuildPutState.OutUnlockRange
    end
    local myUid = LuaEntry.Player.uid
    local ignoreRangeLimit = false
    if buildId ~= nil and (buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or buildId == BuildingTypes.WORM_HOLE_CROSS or buildId == BuildingTypes.FUN_BUILD_MAIN or CheckIgnoreRangeLimit(buildId)) then
      ignoreRangeLimit = true
    end
    if DataCenter.MonsterLockDataManager:GetMonsterDataByPointIndex(index) ~= nil then
      return BuildPutState.PveMonster
    end
    if CS.SceneManager:IsInCity() then
      if ignoreRangeLimit == false and BuildingUtils.IsInMyBaseCircleRange(index, DataCenter.BoardManager:GetBuildMaxRadius()) == false then
        return BuildPutState.OutMyRange
      end
      if not DataCenter.CityZoneManager:CanPutBuildByPoint(index, template.zoneType) then
        if template.zoneType == BuildZoneType.All then
          return BuildPutState.StaticPoint
        end
        return BuildPutState.OutBuildZone
      end
      if not DataCenter.LandLockManager:CanBuildByPointId(index) then
        return BuildPutState.OnLandLock
      end
      if BuildingTypes.LW_BUILD_FLAG ~= buildId and BuildingUtils.IsInFlagPosition(index) then
        return BuildPutState.StaticPoint
      end
      local temp = DataCenter.CityPointManager:GetPointType(index)
      if temp == CityPointType.Building then
        local buildingDate = DataCenter.BuildManager:GetBuildingDataByPointId(index)
        if buildingDate ~= nil and buildingDate.uuid ~= buildUuid then
          return BuildPutState.Building
        end
      elseif temp == CityPointType.Road then
        return BuildPutState.Board
      elseif temp == CityPointType.Garbage then
        return BuildPutState.OnGarbage
      elseif temp == CityPointType.Monster then
        return BuildPutState.Monster
      elseif temp == CityPointType.MonsterReward then
        return BuildPutState.MONSTER_REWARD
      elseif temp == CityPointType.Collect then
        return BuildPutState.Collect
      end
      if resType == nil or resType == ResourceType.None then
        if temp == CityPointType.CollectRange then
          return BuildPutState.CollectRange
        end
      else
        local rangeInfo = DataCenter.CollectResourceManager:GetCollectRangeInfoByIndex(index)
        if rangeInfo ~= nil then
          local collectPara = template.para4
          if not rangeInfo:IsResourceByType(resType, collectPara) then
            return BuildPutState.OtherCollectRange
          end
        else
          return BuildPutState.NoCollectRange
        end
      end
    elseif CS.SceneManager:IsInWorld() then
      if not SceneUtils.IsIndexInWorld(index) then
        return BuildPutState.StaticPoint
      end
      local v2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
      if not BattleFieldUtil.InBattleField() then
        if DataCenter.BirthPointTemplateManager:IsInKingCityOccupiedRange(v2.x, v2.y) then
          return BuildPutState.Building
        end
        if DataCenter.BirthPointTemplateManager:IsInAllianceCityRange(index) then
          return BuildPutState.Building
        end
        ProfilerUtil.BeginSample("BuildingUtils.IsCanPutDownByPoint.World:IsTileWalkable")
        local worldPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, theServerId)
        local walkable = theWorld:IsTileWalkable(worldPos)
        ProfilerUtil.EndSample()
        if not walkable then
          return BuildPutState.StaticPoint
        end
      else
        local sizeInfo = BattleFieldUtil.GetBattleFieldRange(LuaEntry.Player:GetCurWorldType())
        if v2.x <= sizeInfo.minX or v2.x >= sizeInfo.maxX or v2.y <= sizeInfo.minY or v2.y >= sizeInfo.maxY or BattleFieldUtil.IsInBlockRange(index) then
          return BuildPutState.Building
        end
      end
      if BuildingUtils.IsOutOtherBaseSquareRange(index, DataCenter.BoardManager:GetOtherLimitRadius()) == false then
        return BuildPutState.InOtherBaseRange
      end
      if buildId == BuildingTypes.FUN_BUILD_MAIN and isInSeason then
        local info = CS.SceneManager.World:GetPointInfo(index)
        if info ~= nil then
          local thePointType = info.PointType
          if thePointType == WorldPointType.WorldAllianceCollectResource or thePointType == WorldPointType.WorldSuppliesPoint or thePointType == WorldPointType.SURPRISE_POINT or thePointType == WorldPointType.WORLD_CITY_OUTPOST or thePointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER or thePointType == WorldPointType.WORLD_CITY_STRONGHOLD or thePointType == WorldPointType.WORLD_CITY_TRADE or thePointType == WorldPointType.CITY_ALTAR or thePointType == WorldPointType.WORLD_ALLIANCE_CITY or thePointType == WorldPointType.CITY_ATTACHMENT_BUILD or thePointType == WorldPointType.CITY_ATTACHMENT_WALL or thePointType == WorldPointType.ZWL_BUILDING_BUFF or thePointType == WorldPointType.ZWL_BUILDING_TOWER then
            return BuildPutState.Building
          end
        end
        local SeasonType = SeasonUtil.GetSeasonType()
        if SeasonType == SeasonMapType.Desert then
          local worldTileInfo = theWorld:GetWorldTileInfo(index)
          if worldTileInfo ~= nil then
            local desertInfo = worldTileInfo:GetWorldDesertInfo()
            if desertInfo ~= nil and desertInfo.desertId then
              local desert_level = GetTableData(TableName.Desert, desertInfo.desertId, "desert_level")
              if desert_level and 0 < toInt(desert_level) then
                return BuildPutState.NotEmptyDesert
              end
            end
          end
        end
        if SeasonType ~= SeasonMapType.Desert then
          local marchInfo = theWorld:GetMonster(index)
          if marchInfo ~= nil and marchInfo.uuid ~= nil then
            local monsterId = marchInfo.monsterId
            local monster = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(monsterId)
            if monster ~= nil and (monster.special == WorldMonsterSpecialType.CityStrongholdPVE or monster.special == WorldMonsterSpecialType.CityStrongholdPVP or monster.special == WorldMonsterSpecialType.CityStrongholdBOSS) then
              return BuildPutState.HasCityStrongholdMonster
            end
          end
        end
      end
      local temp = theWorld:GetPointInfo(index)
      if temp ~= nil then
        local thePointType = temp.PointType
        if thePointType == WorldPointType.PlayerBuilding then
          cast(temp, typeof(CS.BuildPointInfo))
          if temp == nil or temp.uuid ~= buildUuid then
            return BuildPutState.Building
          end
        elseif thePointType == WorldPointType.PlayerRoad then
          return BuildPutState.Board
        elseif thePointType == WorldPointType.WorldCollectResource then
          if temp.ownerUid ~= myUid then
            return BuildPutState.Collect
          end
        elseif thePointType == WorldPointType.METEORITE_POINT then
          return BuildPutState.Collect
        elseif thePointType == WorldPointType.WorldResource then
          if temp.ownerUid ~= myUid then
            return BuildPutState.OnWorldResource
          end
        elseif thePointType == WorldPointType.SAMPLE_POINT or thePointType == WorldPointType.SAMPLE_POINT_NEW then
          return BuildPutState.OnSample
        elseif thePointType == WorldPointType.EXPLORE_POINT or thePointType == WorldPointType.DETECT_EVENT_PVE then
          return BuildPutState.OnExplore
        elseif thePointType == WorldPointType.GARBAGE then
          return BuildPutState.OnGarbage
        elseif thePointType == WorldPointType.MONSTER_REWARD then
          return BuildPutState.MONSTER_REWARD
        elseif thePointType == WorldPointType.HERO_DISPATCH then
        elseif thePointType == WorldPointType.GHOSTRECON_POINT then
          return BuildPutState.OnGhostrecon
        elseif thePointType == WorldPointType.DRAGON_BUILDING then
          return BuildPutState.Building
        elseif thePointType == WorldPointType.WORLD_ALLIANCE_BUILD or thePointType == WorldPointType.WorldAllianceCollectResource or thePointType == WorldPointType.WorldSuppliesPoint or thePointType == WorldPointType.SURPRISE_POINT or thePointType == WorldPointType.CITY_ATTACHMENT_BUILD or thePointType == WorldPointType.CITY_ATTACHMENT_WALL then
          return BuildPutState.Building
        elseif thePointType == WorldPointType.DRAGON_SCORE_POINT then
          return BuildPutState.Building
        elseif thePointType == WorldPointType.BATTLEFIELD_BUILD then
          return BuildPutState.Building
        elseif thePointType == WorldPointType.WORLD_ALLIANCE_BUILD then
          return BuildPutState.Building
        elseif thePointType == WorldPointType.TREASURE then
          local killerId = temp.killerId
          if killerId ~= nil and killerId ~= 0 and killerId ~= "" then
            return BuildPutState.Ok
          elseif temp.GetWorldTreasureType and temp:GetWorldTreasureType() == WorldTreasureType.WolfShadow and temp.ownerUid == myUid then
            return BuildPutState.Ok
          end
          return BuildPutState.Building
        elseif thePointType == WorldPointType.WINTER_ENTITY or thePointType == WorldPointType.WorldSuppliesPoint or thePointType == WorldPointType.RadarSeasonSnowSurvivor then
          return BuildPutState.Building
        elseif thePointType == WorldPointType.WORLD_ALLIANCE_CITY then
          return BuildPutState.CollectRange
        elseif thePointType == WorldPointType.ZONE_MOBILIZATION then
          return BuildPutState.ZoneMobilizationBuilding
        elseif thePointType == WorldPointType.WORLD_RUIN_DESTROY_BUILDING then
          if temp.allianceId ~= LuaEntry.Player.allianceId then
            return BuildPutState.WORLD_RUIN_DESTROY_BUILDING
          end
        elseif thePointType == WorldPointType.MONSETER_CHALLENGE_NEW_TREASURE then
          return BuildPutState.MONSTER_CHALLENGE_NEW_TREASURE
        elseif thePointType == WorldPointType.DETECT_RETRY_TASK or thePointType == WorldPointType.DETECT_ALLIANCE_CITY_SCOUT_MONSTER then
          return BuildPutState.DetectRetryTask
        elseif thePointType == WorldPointType.TreasureChest then
          return BuildPutState.TreasureChest
        elseif thePointType == WorldPointType.SkyBattle then
          return BuildPutState.SkyBattle
        elseif thePointType == WorldPointType.RADAR_DOMINATOR__COCKATRICE_UNLOCK_1 or thePointType == WorldPointType.RADAR_DOMINATOR__COCKATRICE_UNLOCK_2 then
          return BuildPutState.OnWorldResource
        elseif thePointType == WorldPointType.ALLIANCE_BOSS_S0 then
          return BuildPutState.S0AllianceBuilding
        end
      elseif (resType == nil or resType == ResourceType.None) and WorldBuildUtil.IsCollectRangePoint(index) then
        return BuildPutState.CollectRange
      end
      if not isInSeason and theWorld:GetYellowLand(index) then
        return BuildPutState.AlCityBuilding
      end
      return BuildingUtils.IsCanPutDownInWorldByPoint(index, resType, withOutMarch, theWorld, isInSeason, buildId == BuildingTypes.FUN_BUILD_MAIN, theServerId)
    end
  end
  return BuildPutState.Ok
end

local function IsCanPutDownInWorldByPoint(index, resType, withOutMarch, theWorld, isInSeason, checkSeason, theServerId, ignoreObstacle)
  if not SceneUtils.IsIndexInWorld(index) then
    return BuildPutState.StaticPoint
  end
  local v2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  if not BattleFieldUtil.InBattleField() then
    if DataCenter.BirthPointTemplateManager:IsInKingCityOccupiedRange(v2.x, v2.y) then
      return BuildPutState.Building
    end
    if DataCenter.BirthPointTemplateManager:IsInAllianceCityRange(index) then
      return BuildPutState.Building
    end
    if not ignoreObstacle then
      ProfilerUtil.BeginSample("BuildingUtils.IsCanPutDownInWorldByPoint.World:IsTileWalkable")
      local worldPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, theServerId)
      local walkable = theWorld:IsTileWalkable(worldPos)
      ProfilerUtil.EndSample()
      if not walkable then
        return BuildPutState.StaticPoint
      end
    end
  else
    local sizeInfo = BattleFieldUtil.GetBattleFieldRange(LuaEntry.Player:GetCurWorldType())
    if v2.x <= sizeInfo.minX or v2.x >= sizeInfo.maxX or v2.y <= sizeInfo.minY or v2.y >= sizeInfo.maxY or BattleFieldUtil.IsInBlockRange(index) then
      return BuildPutState.Building
    end
  end
  if BuildingUtils.IsOutOtherBaseSquareRange(index, DataCenter.BoardManager:GetOtherLimitRadius()) == false then
    return BuildPutState.InOtherBaseRange
  end
  if checkSeason and isInSeason then
    local SeasonType = SeasonUtil.GetSeasonType()
    if SeasonType == SeasonMapType.Desert then
      local worldTileInfo = theWorld:GetWorldTileInfo(index)
      if worldTileInfo ~= nil then
        local desertInfo = worldTileInfo:GetWorldDesertInfo()
        if desertInfo ~= nil and desertInfo.desertId then
          local desert_level = GetTableData(TableName.Desert, desertInfo.desertId, "desert_level")
          if desert_level and toInt(desert_level) > 0 then
            return BuildPutState.NotEmptyDesert
          end
        end
      end
    end
    if SeasonType == SeasonMapType.CityStronghold then
      local marchInfo = theWorld:GetMonster(index)
      if marchInfo ~= nil and marchInfo.uuid ~= nil then
        local monsterId = marchInfo.monsterId
        local monster = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(monsterId)
        if monster ~= nil and (monster.special == WorldMonsterSpecialType.CityStrongholdPVE or monster.special == WorldMonsterSpecialType.CityStrongholdPVP or monster.special == WorldMonsterSpecialType.CityStrongholdBOSS) then
          return BuildPutState.HasCityStrongholdMonster
        end
      end
    end
  end
  local temp = theWorld:GetPointInfo(index)
  if temp ~= nil then
    local thePointType = temp.PointType
    if thePointType == WorldPointType.PlayerBuilding then
      cast(temp, typeof(CS.BuildPointInfo))
      if temp == nil or temp.uuid ~= buildUuid then
        return BuildPutState.Building
      end
    elseif thePointType == WorldPointType.PlayerRoad then
      return BuildPutState.Board
    elseif thePointType == WorldPointType.WorldCollectResource then
      if temp.ownerUid ~= myUid then
        return BuildPutState.Collect
      end
    elseif thePointType == WorldPointType.WorldResource then
      if temp.ownerUid ~= myUid then
        return BuildPutState.OnWorldResource
      end
    elseif thePointType == WorldPointType.SAMPLE_POINT or thePointType == WorldPointType.SAMPLE_POINT_NEW then
      return BuildPutState.OnSample
    elseif thePointType == WorldPointType.EXPLORE_POINT or thePointType == WorldPointType.DETECT_EVENT_PVE then
      return BuildPutState.OnExplore
    elseif thePointType == WorldPointType.GARBAGE then
      return BuildPutState.OnGarbage
    elseif thePointType == WorldPointType.MONSTER_REWARD then
      return BuildPutState.MONSTER_REWARD
    elseif thePointType == WorldPointType.HERO_DISPATCH then
    elseif thePointType == WorldPointType.DRAGON_BUILDING then
      return BuildPutState.Building
    elseif thePointType == WorldPointType.DRAGON_SCORE_POINT then
      return BuildPutState.Building
    elseif thePointType == WorldPointType.BATTLEFIELD_BUILD then
      return BuildPutState.Building
    elseif thePointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      return BuildPutState.Building
    elseif thePointType == WorldPointType.TREASURE then
      return BuildPutState.Building
    elseif thePointType == WorldPointType.WINTER_ENTITY or thePointType == WorldPointType.WorldSuppliesPoint or thePointType == WorldPointType.RadarSeasonSnowSurvivor then
      return BuildPutState.Building
    elseif thePointType == WorldPointType.ZONE_MOBILIZATION then
      return BuildPutState.ZoneMobilizationBuilding
    elseif thePointType == WorldPointType.MONSETER_CHALLENGE_NEW_TREASURE then
      return BuildPutState.MONSTER_CHALLENGE_NEW_TREASUR
    elseif thePointType == WorldPointType.ALLIANCE_BOSS_S0 then
      return BuildPutState.S0AllianceBuilding
    end
  elseif (resType == nil or resType == ResourceType.None) and WorldBuildUtil.IsCollectRangePoint(index) then
    return BuildPutState.CollectRange
  end
  if not isInSeason and theWorld:GetYellowLand(index) then
    return BuildPutState.AlCityBuilding
  end
  if not withOutMarch then
    local putState = BuildingUtils.CanPutDownWithMarch(index)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

local function CanPutDownWithMarch(index, checkAllMonster)
  if IsNumber(index) then
    local tmp = index
    index = {}
    table.insert(index, tmp)
  end
  local marchList = DataCenter.WorldMarchDataManager:GetAllMarches()
  if marchList ~= nil then
    for marchUuid, marchInfo in pairs(marchList) do
      local monster
      if marchInfo and marchInfo.monsterId then
        monster = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(marchInfo.monsterId)
      end
      if monster ~= nil then
        local size = marchInfo:GetMarchBlockSize()
        if checkAllMonster or 0 < size then
          for k, v in pairs(index) do
            if size < 2 and v == marchInfo.targetPos then
              if checkAllMonster and monster.special == 0 then
                return BuildPutState.WorldMonster
              end
              return BuildPutState.WorldBoss
            end
            local v2 = SceneUtils.IndexToTilePos(v, ForceChangeScene.World)
            local pos = SceneUtils.IndexToTilePos(marchInfo.targetPos, ForceChangeScene.World)
            local circle = tonumber(monster.size) * 0.5
            local distanceX = math.abs(v2.x - pos.x)
            local distanceY = math.abs(v2.y - pos.y)
            if circle >= distanceX and circle >= distanceY then
              return BuildPutState.WorldMonster
            end
          end
        end
      end
    end
  end
  return BuildPutState.Ok
end

local function IsCanPutDownBoardByPoint(index)
  if CS.SceneManager.World:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if BuildingUtils.IsInMyBaseCircleRange(index, DataCenter.BoardManager:GetBuildMaxRadius()) == false then
    return BuildPutState.OutMyRange
  end
  if not DataCenter.LandLockManager:CanBuildByPointId(index) then
    return BuildPutState.OnLandLock
  end
  if DataCenter.MonsterLockDataManager:GetMonsterDataByPointIndex(index) ~= nil then
    return BuildPutState.PveMonster
  end
  if DataCenter.BaseExpansionTemplateManager:IsPutNoPoint(index) then
    return BuildPutState.OnBaseExpansion
  end
  if CS.SceneManager:IsInCity() then
    local temp = DataCenter.CityPointManager:GetPointType(index)
    if temp == CityPointType.Building then
      return BuildPutState.Building
    elseif temp == CityPointType.Garbage then
      return BuildPutState.OnGarbage
    elseif temp == CityPointType.Monster then
      return BuildPutState.WorldMonster
    elseif temp == CityPointType.MonsterReward then
      return BuildPutState.MONSTER_REWARD
    elseif temp == CityPointType.Collect then
      return BuildPutState.Collect
    elseif temp == CityPointType.CollectRange then
      return BuildPutState.CollectRange
    end
  elseif CS.SceneManager:IsInWorld() then
    local myUid = LuaEntry.Player.uid
    if BuildingUtils.IsOutOtherBaseSquareRange(index, DataCenter.BoardManager:GetOtherLimitRadius()) == false then
      return BuildPutState.InOtherBaseRange
    end
    local temp = CS.SceneManager.World:GetPointInfo(index)
    if temp ~= nil then
      local thePointType = temp.PointType
      if thePointType == WorldPointType.PlayerBuilding then
        return BuildPutState.Building
      elseif thePointType == WorldPointType.PlayerRoad then
        if temp.ownerUid ~= myUid then
          return BuildPutState.Board
        end
      elseif thePointType == WorldPointType.WorldCollectResource then
        return BuildPutState.Collect
      elseif thePointType == WorldPointType.WorldResource then
        return BuildPutState.OnWorldResource
      elseif thePointType == WorldPointType.SAMPLE_POINT or thePointType == WorldPointType.SAMPLE_POINT_NEW then
        return BuildPutState.OnSample
      elseif thePointType == WorldPointType.EXPLORE_POINT or thePointType == WorldPointType.DETECT_EVENT_PVE then
        return BuildPutState.OnExplore
      elseif thePointType == WorldPointType.GARBAGE then
        return BuildPutState.OnGarbage
      elseif thePointType == WorldPointType.MONSTER_REWARD then
        return BuildPutState.MONSTER_REWARD
      end
    elseif WorldBuildUtil.IsCollectRangePoint(index) then
      return BuildPutState.CollectRange
    end
  end
  return BuildPutState.Ok
end

local function IsCanShowCollectGreenByPoint(index)
  if CS.SceneManager.World:IsInMapByIndex(index) == false then
    return false
  end
  if CS.SceneManager:IsInCity() then
    local temp = DataCenter.CityPointManager:GetPointType(index)
    if temp ~= CityPointType.Other then
      return false
    end
  elseif CS.SceneManager:IsInWorld() then
    local temp = CS.SceneManager.World:GetPointInfo(index)
    if temp ~= nil then
      return false
    end
  end
  return true
end

local function IsInMyBaseSquareRange(point, radius)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil and mainBuild:IsActive() then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(mainBuild.itemId)
    if buildTemplate ~= nil then
      return BuildingUtils.IsInRangeBySquare(mainBuild.pointId, point, radius, radius, buildTemplate.tileX, buildTemplate.tileY)
    end
  end
  return true
end

local function IsInRangeBySquare(pos1, pos2, widthRadius, heightRadius, tileX, tileY)
  pos1 = BuildingUtils.GetBuildModelCenter(pos1, tileX, tileY)
  local vecPos1 = SceneUtils.IndexToTilePos(pos1)
  local vecPos2 = SceneUtils.IndexToTilePos(pos2)
  local xMin = vecPos1.x - widthRadius
  local xMax = vecPos1.x + widthRadius
  local yMin = vecPos1.y - heightRadius
  local yMax = vecPos1.y + heightRadius
  if tileX % 2 == 0 then
    yMax = yMax - 1
  end
  if tileY % 2 == 0 then
    yMax = yMax - 1
  end
  return xMin <= vecPos2.x and xMax >= vecPos2.x and yMin <= vecPos2.y and yMax >= vecPos2.y
end

local function IsOutOtherBaseSquareRange(point, radius, tileX, tileY)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  local buildDes = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  local myUid = LuaEntry.Player.uid
  if mainBuild ~= nil and buildDes ~= nil then
    local vec2 = SceneUtils.IndexToTilePos(mainBuild.pointId)
    local list = DataCenter.BirthPointTemplateManager:GetPointInMyBaseRange(vec2.x, vec2.y)
    for k, v in pairs(list) do
      local perIndex = SceneUtils.TilePosToIndex(v)
      local info = CS.SceneManager.World:GetPointInfo(perIndex)
      if info ~= nil and info.PointType == WorldPointType.PlayerBuilding and info.ownerUid ~= myUid then
        cast(info, typeof(CS.BuildPointInfo))
        if info ~= nil and info.itemId == BuildingTypes.FUN_BUILD_MAIN and tileX and tileY then
          local buildIndex = BuildingUtils.GetBuildModelCenter(point, tileX, tileY)
          local buildVec = SceneUtils.IndexToTilePos(buildIndex)
          local mainRange = BuildingUtils.GetAllNeighborsPos4(v, tileX, tileY)
          for a, b in pairs(mainRange) do
            local distanceX = math.abs(buildVec.x - b.x)
            local distanceY = math.abs(buildVec.y - b.y)
            if radius >= distanceY and radius >= distanceX then
              return false
            end
          end
        end
      end
    end
  end
  return true
end

local function IsInMyBaseCircleRange(point, radius)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil and mainBuild:IsActive() then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(mainBuild.itemId)
    if buildTemplate ~= nil then
      return BuildingUtils.IsInRangeBySquare(mainBuild.pointId, point, radius, radius, buildTemplate.tileX, buildTemplate.tileY)
    end
  end
  return true
end

local function IsInMainSubRange(point, mainBuildId)
  local alMainBuild = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(mainBuildId)
  if alMainBuild ~= nil then
    for k, v in pairs(alMainBuild) do
      if v.destroyStartTime <= 0 then
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.itemId)
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.itemId, v.level)
        if template ~= nil and levelTemplate ~= nil and BuildingUtils.IsInRangeBySquare(v.pointId, point, levelTemplate.offer_range, levelTemplate.offer_range, template.tileX, template.tileY) then
          return true
        end
      end
    end
  end
  return false
end

local function ShowPutAllianceBuild(buildId, buildUuid, point, buildTopType, notBuildListStr, fromPanel, serverId, forceServer)
  serverId = checknumber(serverId)
  forceServer = forceServer == true
  CS.SceneManager.World:UICreateAllianceBuilding(buildId, buildUuid, point, buildTopType, notBuildListStr, serverId, forceServer)
  DataCenter.BuildManager:SetShowPutBuildFromPanel(fromPanel)
end

local function ShowPutBuild(buildId, topType, buildUuid, point, notBuildListStr, fromPanel)
  CS.SceneManager.World:UICreateBuilding(buildId, buildUuid, point, topType, notBuildListStr)
  DataCenter.BuildManager:SetShowPutBuildFromPanel(fromPanel)
  EventManager:GetInstance():Broadcast(EventId.GF_begin_put_building, buildId)
end

local function GetAllPointsByCircle(point, radius)
  local result = {}
  for x = -radius, radius do
    for y = -radius, radius do
      local temp = {}
      temp.x = point.x + x
      temp.y = point.y + y
      if CS.SceneManager.World:IsInMap(temp) == true and x * x + y * y <= radius * radius then
        table.insert(result, temp)
      end
    end
  end
  return result
end

local function GetAllPointsBySquare(point, radius)
  local result = {}
  for x = -radius, radius do
    for y = -radius, radius do
      local temp = {}
      temp.x = point.x + x
      temp.y = point.y + y
      if CS.SceneManager.World:IsInMap(temp) == true then
        table.insert(result, temp)
      end
    end
  end
  return result
end

local function GetOutermostIndexByIndex(index, radius, maxX, maxY, forceType)
  local result = {}
  local temDic = {}
  local circle = SceneUtils.IndexToTilePos(index, forceType)
  local offset = {}
  local tempPos = {}
  local tempIndex = 0
  for i = 0, radius do
    for j = 0, 1 do
      i = -i
      if radius <= maxX then
        offset.x = -radius
        offset.y = i
        tempPos.x = circle.x + offset.x
        tempPos.y = circle.y + offset.y
        tempIndex = SceneUtils.TilePosToIndex(tempPos, forceType)
        if temDic[tempIndex] == nil then
          temDic[tempIndex] = true
          table.insert(result, tempIndex)
        end
        offset.x = radius
        offset.y = i
        tempPos.x = circle.x + offset.x
        tempPos.y = circle.y + offset.y
        tempIndex = SceneUtils.TilePosToIndex(tempPos, forceType)
        if temDic[tempIndex] == nil then
          temDic[tempIndex] = true
          table.insert(result, tempIndex)
        end
      end
      if radius <= maxY then
        offset.x = i
        offset.y = radius
        tempPos.x = circle.x + offset.x
        tempPos.y = circle.y + offset.y
        tempIndex = SceneUtils.TilePosToIndex(tempPos, forceType)
        if temDic[tempIndex] == nil then
          temDic[tempIndex] = true
          table.insert(result, tempIndex)
        end
        offset.x = i
        offset.y = -radius
        tempPos.x = circle.x + offset.x
        tempPos.y = circle.y + offset.y
        tempIndex = SceneUtils.TilePosToIndex(tempPos, forceType)
        if temDic[tempIndex] == nil then
          temDic[tempIndex] = true
          table.insert(result, tempIndex)
        end
      end
    end
  end
  return result
end

local function GetPointByBuildCanPut(buildId, point, noBuildList)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    local resourceType = DataCenter.BuildManager:GetResourceTypeByBuildId(buildId)
    if resourceType == nil or resourceType == ResourceType.None then
      local recommendList = buildTemplate:GetReCommendPosition()
      if recommendList ~= nil and table.count(recommendList) > 0 then
        local put = 0
        for k, v in ipairs(recommendList) do
          put = BuildingUtils.IsCanPutDownByBuild(buildId, v, 0, noBuildList)
          if put == BuildPutState.Ok then
            return v
          end
        end
        local v = recommendList[1]
        local tileX = buildTemplate.tileX
        local tileY = buildTemplate.tileY
        local pointId = SceneUtils.GetIndexByOffset(v, tileX, 0)
        put = BuildingUtils.IsCanPutDownByBuild(buildId, pointId, 0, noBuildList)
        if put == BuildPutState.Ok then
          return pointId
        end
        pointId = SceneUtils.GetIndexByOffset(v, 0, -tileY)
        put = BuildingUtils.IsCanPutDownByBuild(buildId, pointId, 0, noBuildList)
        if put == BuildPutState.Ok then
          return pointId
        end
        pointId = SceneUtils.GetIndexByOffset(v, -tileX, 0)
        put = BuildingUtils.IsCanPutDownByBuild(buildId, pointId, 0, noBuildList)
        if put == BuildPutState.Ok then
          return pointId
        end
        pointId = SceneUtils.GetIndexByOffset(v, 0, tileY)
        put = BuildingUtils.IsCanPutDownByBuild(buildId, pointId, 0, noBuildList)
        if put == BuildPutState.Ok then
          return pointId
        end
      end
      if buildTemplate.build_type == BuildType.Second then
        if buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or buildId == BuildingTypes.WORM_HOLE_CROSS then
          return point
        end
        local secondBuildPoint = BuildingUtils.GetSecondBuildCanPlacePoint(buildId, noBuildList)
        if 0 < secondBuildPoint then
          return secondBuildPoint
        else
          local size = CS.UIUtils.GetCurScreenMaxRadiusSize()
          local radius = math.max(size.x, size.y)
          for i = 0, radius do
            local list = BuildingUtils.GetOutermostIndexByIndex(point, i, size.x, size.y)
            if list ~= nil then
              local length = #list
              for j = 1, length do
                local put = BuildingUtils.IsCanPutDownByBuild(buildId, list[j], 0, noBuildList)
                if put == BuildPutState.Ok then
                  return list[j]
                end
              end
            end
          end
          return point
        end
      elseif buildTemplate.tab_type ~= UIBuildListTabType.Decorate then
        local saveBuildPlacePoint = BuildingUtils.GetSaveBuildPlaceTypePoint(buildId, noBuildList)
        if 0 < saveBuildPlacePoint then
          return saveBuildPlacePoint
        end
        local nearestBuildPlacePoint = BuildingUtils.GetNearestCanPlaceRoadRangePoint(buildId, noBuildList)
        if 0 < nearestBuildPlacePoint then
          return nearestBuildPlacePoint
        end
      end
      local size = CS.UIUtils.GetCurScreenMaxRadiusSize()
      local radius = math.max(size.x, size.y)
      for i = 0, radius do
        local list = BuildingUtils.GetOutermostIndexByIndex(point, i, size.x, size.y)
        if list ~= nil then
          local length = #list
          for j = 1, length do
            local put = BuildingUtils.IsCanPutDownByBuild(buildId, list[j], 0, noBuildList)
            if put == BuildPutState.Ok then
              return list[j]
            end
          end
        end
      end
    else
      local pointId = DataCenter.CollectResourceManager:GetNearestResourcePointByResourceType(resourceType, buildTemplate.para4)
      if pointId ~= nil then
        local list = DataCenter.CollectResourceManager:GetAllCollectRangePoint(pointId)
        if list ~= nil then
          local posVec = DataCenter.BuildManager.main_city_pos
          table.sort(list, function(a, b)
            local posA = SceneUtils.IndexToTilePos(a)
            posA.x = posA.x - posVec.x
            posA.y = posA.y - posVec.y
            local posB = SceneUtils.IndexToTilePos(b)
            posB.x = posB.x - posVec.x
            posB.y = posB.y - posVec.y
            local disA = posA.x * posA.x + posA.y * posA.y
            local disB = posB.x * posB.x + posB.y * posB.y
            return disA < disB
          end)
          for k, v in ipairs(list) do
            local put = BuildingUtils.IsCanPutDownByBuild(buildId, v, 0, noBuildList)
            if put == BuildPutState.Ok then
              return v
            end
          end
          if table.count(list) > 0 then
            return list[1]
          end
        end
        return pointId
      end
    end
  end
  return point
end

local function GetSaveBuildPlaceTypePoint(buildId, noBuildList)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    local zoneType = buildTemplate.zoneType
    if zoneType ~= BuildZoneType.No then
      local zone = DataCenter.BuildTemplateManager:GetZoneByZoneType(zoneType)
      if zone ~= nil then
        local mainPosX, mainPosY
        local addPoint = {}
        if noBuildList ~= nil then
          for k, v in pairs(noBuildList) do
            addPoint[v] = false
          end
        end
        local points = {}
        local tileX = buildTemplate.tileX
        local tileY = buildTemplate.tileY
        if zone[BuildZoneMainType.Main] ~= nil then
          for k, v in ipairs(zone[BuildZoneMainType.Main]) do
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v.id)
            if list ~= nil then
              for k1, v1 in ipairs(list) do
                if mainPosX == nil and mainPosY == nil then
                  local pos = SceneUtils.IndexToTilePos(v1.pointId)
                  mainPosX = pos.x
                  mainPosY = pos.y
                end
                if v.id ~= BuildingTypes.APS_BUILD_FARM_FIELD then
                  local originalPoint = v1.pointId
                  local originalTileX = v.tileX
                  local originalTileY = v.tileY
                  local neighborPoints = {}
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, 0, tileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX - originalTileX, tileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, 0, -originalTileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX - originalTileX, -originalTileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, -originalTileX, 0))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, -originalTileX, tileY - originalTileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX, 0))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX, tileY - originalTileY))
                  for j = 1, #neighborPoints do
                    local point = neighborPoints[j]
                    if addPoint[point] == nil then
                      local isPutDown = BuildingUtils.IsCanPutDownByBuild(buildId, point, 0, noBuildList)
                      if isPutDown == BuildPutState.Ok then
                        local pos = SceneUtils.IndexToTilePos(point)
                        local dis = (pos.x - mainPosX) * (pos.x - mainPosX) + (pos.y - mainPosY) * (pos.y - mainPosY)
                        local isHaveRoad = false
                        local list2 = BuildingUtils.GetBuildRangePoint(buildId, point)
                        if list2 ~= nil and 0 < #list2 then
                          for m = 1, #list2 do
                            if isHaveRoad == false and CS.SceneManager.World:IsSelfRoad(list2[m]) == true then
                              isHaveRoad = true
                            end
                          end
                        end
                        addPoint[point] = true
                        local oneData = {}
                        oneData.item1 = point
                        oneData.item2 = dis
                        oneData.item3 = isHaveRoad
                        table.insert(points, oneData)
                      else
                        addPoint[point] = false
                      end
                    end
                  end
                end
              end
            end
          end
        end
        if mainPosX == nil and mainPosY == nil then
          mainPosX = DataCenter.BuildManager.main_city_pos.x
          mainPosY = DataCenter.BuildManager.main_city_pos.y
        end
        if zone[BuildZoneMainType.Sub] ~= nil then
          for k, v in ipairs(zone[BuildZoneMainType.Sub]) do
            if v.id ~= BuildingTypes.APS_BUILD_FARM_FIELD then
              local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v.id)
              if list ~= nil then
                for k1, v1 in ipairs(list) do
                  local originalPoint = v1.pointId
                  local originalTileX = v.tileX
                  local originalTileY = v.tileY
                  local neighborPoints = {}
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, 0, tileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX - originalTileX, tileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, 0, -originalTileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX - originalTileX, -originalTileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, -originalTileX, 0))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, -originalTileX, tileY - originalTileY))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX, 0))
                  table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX, tileY - originalTileY))
                  for j = 1, #neighborPoints do
                    local point = neighborPoints[j]
                    if addPoint[point] == nil then
                      local isPutDown = BuildingUtils.IsCanPutDownByBuild(buildId, point, 0, noBuildList)
                      if isPutDown == BuildPutState.Ok then
                        local pos = SceneUtils.IndexToTilePos(point)
                        local dis = (pos.x - mainPosX) * (pos.x - mainPosX) + (pos.y - mainPosY) * (pos.y - mainPosY)
                        local isHaveRoad = false
                        local list2 = BuildingUtils.GetBuildRangePoint(buildId, point)
                        if list2 ~= nil and 0 < #list2 then
                          for m = 1, #list2 do
                            if isHaveRoad == false and CS.SceneManager.World:IsSelfRoad(list2[m]) == true then
                              isHaveRoad = true
                            end
                          end
                        end
                        addPoint[point] = true
                        local oneData = {}
                        oneData.item1 = point
                        oneData.item2 = dis
                        oneData.item3 = isHaveRoad
                        table.insert(points, oneData)
                      else
                        addPoint[point] = false
                      end
                    end
                  end
                end
              end
            end
          end
        end
        table.sort(points, function(a, b)
          if a.item2 ~= b.item2 then
            return a.item2 < b.item2
          elseif a.item3 ~= b.item3 then
            return a.item3
          end
          return false
        end)
        if 0 < #points then
          return points[1].item1
        end
      end
    end
  end
  return 0
end

local function GetBuildRangePoint(buildId, pointId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    local tileX = buildTemplate.tileX
    local tileY = buildTemplate.tileY
    local neighborPoints = {}
    for i = 0, tileX - 1 do
      table.insert(neighborPoints, SceneUtils.GetIndexByOffset(pointId, -i, 1))
      table.insert(neighborPoints, SceneUtils.GetIndexByOffset(pointId, -i, -tileY))
      table.insert(neighborPoints, SceneUtils.GetIndexByOffset(pointId, -tileX, -i))
      table.insert(neighborPoints, SceneUtils.GetIndexByOffset(pointId, 1, -i))
    end
    return neighborPoints
  end
end

local function GetNearestCanPlaceRoadRangePoint(buildId, noBuildList)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    local allList = DataCenter.BoardManager:GetAllRoadData()
    if allList ~= nil then
      local addPoint = {}
      if noBuildList ~= nil then
        for k, v in pairs(noBuildList) do
          addPoint[v] = false
        end
      end
      local points = {}
      local mainPosX = DataCenter.BuildManager.main_city_pos.x
      local mainPosY = DataCenter.BuildManager.main_city_pos.y
      if buildTemplate.zoneMainType == BuildZoneMainType.Sub then
        local zone = DataCenter.BuildTemplateManager:GetZoneByZoneType(buildTemplate.zoneType)
        if zone ~= nil and zone[BuildZoneMainType.Main] ~= nil then
          local buildData, list
          for k, v in ipairs(zone[BuildZoneMainType.Main]) do
            list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v)
            if list ~= nil then
              for k2, v2 in ipairs(list) do
                buildData = v2
                break
              end
            end
            if buildData ~= nil then
              break
            end
          end
          if buildData ~= nil then
            local vec = SceneUtils.IndexToTilePos(buildData.pointId)
            mainPosX = vec.x
            mainPosY = vec.y
          end
        end
      end
      local tileX = buildTemplate.tileX
      local tileY = buildTemplate.tileY
      local tile = BuildTilesType.One
      for i = 1, #allList do
        if allList[i] ~= nil then
          local temp = allList[i]
          if temp.pointId ~= nil then
            local originalPoint = temp.pointId
            local neighborPoints = {}
            for t = 0, tile - 1 do
              table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, t, tileY))
              table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, t, -1))
              table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, -1, t))
              table.insert(neighborPoints, SceneUtils.GetIndexByOffset(originalPoint, tileX, t))
            end
            for j = 1, #neighborPoints do
              local point = neighborPoints[j]
              if addPoint[point] == nil then
                local isPutDown = BuildingUtils.IsCanPutDownByBuild(buildId, point, 0, noBuildList)
                if isPutDown == BuildPutState.Ok then
                  local pos = SceneUtils.IndexToTilePos(point)
                  local dis = (pos.x - mainPosX) * (pos.x - mainPosX) + (pos.y - mainPosY) * (pos.y - mainPosY)
                  addPoint[point] = true
                  local oneData = {}
                  oneData.item1 = point
                  oneData.item2 = dis
                  table.insert(points, oneData)
                else
                  addPoint[point] = false
                end
              end
            end
          end
        end
      end
      table.sort(points, function(a, b)
        if a.item2 ~= b.item2 then
          return a.item2 < b.item2
        end
        return false
      end)
      if 0 < #points then
        return points[1].item1
      end
    end
  end
  return 0
end

local function GetSecondBuildCanPlacePoint(buildId, noBuildList)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil and buildTemplate.build_type == BuildType.Second then
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(buildTemplate.sup_main_build_id)
    if mainBuild ~= nil and mainBuild.state ~= BuildingStateType.FoldUp then
      local addPoint = {}
      if noBuildList ~= nil then
        for k, v in pairs(noBuildList) do
          addPoint[v] = false
        end
      end
      local param = BuildingUtils.GetPlaceDirectionByMainBuild(buildTemplate.sup_main_build_id, mainBuild.pointId)
      if param == nil then
        return 0
      end
      local isAllContinue = true
      local isRowContinue = true
      local tileX = buildTemplate.tileX
      local tileY = buildTemplate.tileY
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(mainBuild.itemId, mainBuild.level)
      if levelTemplate ~= nil then
        local row = tonumber(levelTemplate.para1)
        local x = 0
        local y = 0
        local originalIndex = param.item1
        local deltaX = -tileX
        local deltaY = -tileY
        if param.item2 == true and param.item3 == true then
          deltaX = tileX
          deltaY = tileY
        elseif param.item2 == false and param.item4 == true then
          deltaX = tileX
          deltaY = tileY
        end
        local useRowX = param.item2
        while isAllContinue do
          isAllContinue = false
          for i = 0, row - 1 do
            if useRowX == true then
              x = i * deltaX
            else
              y = i * deltaY
            end
            local index = SceneUtils.GetIndexByOffset(originalIndex, x, y)
            if addPoint[index] == nil then
              local build = DataCenter.BuildManager:GetBuildingDataByPointId(index)
              if build == nil or build.itemId ~= buildId then
                if BuildingUtils.IsCanPutDownByBuild(buildId, index, 0, noBuildList) == BuildPutState.Ok then
                  return index
                end
              else
                isAllContinue = true
              end
            else
              isAllContinue = true
            end
          end
          if useRowX == true then
            if param.item4 then
              y = y + tileX
            else
              y = y - tileY
            end
          elseif param.item3 then
            x = x + tileX
          else
            x = x - tileY
          end
        end
      end
    end
  end
  return 0
end

local function GetPlaceDirectionByMainBuild(mainBuildId, pointId)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(mainBuildId)
  if template ~= nil then
    local mainPosX = DataCenter.BuildManager.main_city_pos.x
    local mainPosY = DataCenter.BuildManager.main_city_pos.y
    local pos = SceneUtils.IndexToTilePos(pointId)
    local tileX = template.tileX
    local tileY = template.tileY
    local topRoad = false
    local downRoad = false
    local leftRoad = false
    local rightRoad = false
    for i = 0, tileX - 1 do
      if topRoad == false then
        topRoad = CS.SceneManager.World:IsSelfRoad(SceneUtils.GetIndexByOffset(pointId, -i, 1))
      end
      if downRoad == false then
        downRoad = CS.SceneManager.World:IsSelfRoad(SceneUtils.GetIndexByOffset(pointId, -i, -tileY))
      end
      if leftRoad == false then
        leftRoad = CS.SceneManager.World:IsSelfRoad(SceneUtils.GetIndexByOffset(pointId, -tileX, -i))
      end
      if rightRoad == false then
        rightRoad = CS.SceneManager.World:IsSelfRoad(SceneUtils.GetIndexByOffset(pointId, 1, -i))
      end
    end
    if topRoad == true then
      if rightRoad == true then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, 0, -tileY)
        oneData.item2 = true
        oneData.item3 = false
        oneData.item4 = false
        return oneData
      end
      if leftRoad == true then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, -tileX + 1, -tileY)
        oneData.item2 = true
        oneData.item3 = true
        oneData.item4 = false
        return oneData
      end
      if mainPosX < pos.x then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, -tileX + 1, -tileY)
        oneData.item2 = true
        oneData.item3 = true
        oneData.item4 = false
        return oneData
      else
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, 0, -tileY)
        oneData.item2 = true
        oneData.item3 = false
        oneData.item4 = false
        return oneData
      end
    end
    if downRoad == true then
      if rightRoad == true then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, 0, 1)
        oneData.item2 = true
        oneData.item3 = false
        oneData.item4 = true
        return oneData
      end
      if leftRoad == true then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, -tileX + 1, 1)
        oneData.item2 = true
        oneData.item3 = true
        oneData.item4 = true
        return oneData
      end
      if mainPosX < pos.x then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, -tileX + 1, 1)
        oneData.item2 = true
        oneData.item3 = true
        oneData.item4 = true
        return oneData
      else
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, 0, 1)
        oneData.item2 = true
        oneData.item3 = false
        oneData.item4 = true
        return oneData
      end
    end
    if rightRoad == true then
      if mainPosY < pos.y then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, -tileX, -tileY + 1)
        oneData.item2 = false
        oneData.item3 = false
        oneData.item4 = true
        return oneData
      else
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, -tileX, 0)
        oneData.item2 = false
        oneData.item3 = false
        oneData.item4 = false
        return oneData
      end
    end
    if leftRoad == true then
      if mainPosY < pos.y then
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, 1, -tileY + 1)
        oneData.item2 = false
        oneData.item3 = true
        oneData.item4 = true
        return oneData
      else
        local oneData = {}
        oneData.item1 = SceneUtils.GetIndexByOffset(pointId, 1, 0)
        oneData.item2 = false
        oneData.item3 = true
        oneData.item4 = false
        return oneData
      end
    end
  end
end

local function IsCanBuildNext(buildId, sendCount)
  local result = false
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if template ~= nil then
    local foldCount = 0
    local foldList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(buildId)
    if foldList ~= nil then
      foldCount = table.count(foldList)
    end
    local canBuild = DataCenter.BuildManager:GetCurMaxBuildNum(buildId)
    local now = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
    local canBuildNum = canBuild - now - sendCount
    local needResourceTime = 2 - foldCount
    if needResourceTime < 0 then
      needResourceTime = 0
    end
    if 1 < canBuildNum then
      result = true
      if 0 < needResourceTime then
        local resources = template:GetNeedResource()
        if resources ~= nil then
          for k, v in pairs(resources) do
            local resourceType = v.resourceType
            local count = v.count * needResourceTime
            local own = LuaEntry.Resource:GetCntByResType(resourceType)
            if count > own then
              return false
            end
          end
        end
      end
    end
  end
  return result
end

local function GetBuildModelCenter(mainIndex, tileX, tileY)
  tileY = tileY or tileX
  return SceneUtils.GetIndexByOffset(mainIndex, -BuildingUtils.GetCircleRange(tileX), -BuildingUtils.GetCircleRange(tileY))
end

local function GetBuildModelCenterVec(mainIndex, tileX, tileY, forceType, serverId)
  if tileX == nil then
    tileX = 1
  end
  if tileY == nil then
    tileY = 1
  end
  tileY = tileY or tileX
  local ret = SceneUtils.TileIndexToWorld(mainIndex, forceType, serverId or LuaEntry.Player:GetCurServerId())
  ret.x = ret.x + 1 - tileX
  ret.z = ret.z + 1 - tileY
  return ret
end

local function GetBuildMainVecByModelCenter(centerIndex, tile)
  local delta = tile - 1
  return SceneUtils.TileIndexToWorld(centerIndex) + Vector3.New(delta, 0, delta)
end

local function GetBuildModelDownVec(mainIndex, tileX, tileY)
  tileY = tileY or tileX
  return SceneUtils.TileIndexToWorld(mainIndex) + Vector3.New(-(tileX - 1), 0, -1 - (tileY - 1) * 2)
end

local function GetAllCanPutPointsByBuildId(pointId, buildId, buildUuid)
  local result = {}
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if template ~= nil then
    if template.build_type == BuildType.Second then
      local allMainBuild = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(template.sup_main_build_id)
      if allMainBuild ~= nil then
        table.walk(allMainBuild, function(k, v)
          local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.itemId, v.level)
          if levelTemplate ~= nil and levelTemplate.offer_range <= MaxShowBuildBlockRange then
            local pos = SceneUtils.IndexToTilePos(v.pointId)
            local list = BuildingUtils.GetAllPointsBySquare(pos, levelTemplate.offer_range)
            if list ~= nil then
              table.walk(list, function(a, b)
                local index = SceneUtils.TilePosToIndex(b)
                local put = BuildingUtils.IsCanPutDownByBuild(buildId, index, buildUuid)
                if put == BuildPutState.Ok then
                  table.insert(result, index)
                end
              end)
            end
          end
        end)
      end
    elseif template.build_type == BuildType.Main then
      local level = 1
      if buildUuid ~= nil and buildUuid ~= 0 then
        local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
        if data ~= nil then
          level = data.level
        end
      end
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if levelTemplate ~= nil and levelTemplate.offer_range <= MaxShowBuildBlockRange then
        local pos = SceneUtils.IndexToTilePos(pointId)
        local list = BuildingUtils.GetAllPointsBySquare(pos, levelTemplate.offer_range)
        if list ~= nil then
          table.walk(list, function(k, v)
            local index = SceneUtils.TilePosToIndex(v)
            local put = BuildingUtils.IsCanPutDownByBuild(buildId, index, buildUuid)
            if put == BuildPutState.Ok then
              table.insert(result, index)
            end
          end)
        end
      end
    end
  end
  return result
end

local function IsBuildResourceEmpty(buildId, pointId)
  local resourceType = DataCenter.BuildManager:GetResourceTypeByBuildId(buildId)
  if resourceType == nil or resourceType == ResourceType.None then
    return false
  end
  local rangeList = BuildingUtils.GetAllNeighborsPos4(pointId, CS.SceneManager.World:GetCollectResourceBuildRange(), CS.SceneManager.World:GetCollectResourceBuildRange())
  local collectInfos = {}
  table.walk(rangeList, function(k, v)
    local tempIndex = SceneUtils.TilePosToIndex(v)
    if CS.SceneManager.World:IsCollectPoint(tempIndex) then
      table.insert(collectInfos, CS.SceneManager.World:GetResourcePointInfoByIndex(tempIndex))
    end
  end)
  if 0 < #collectInfos then
    for k, v in pairs(collectInfos) do
      local type = LocalController:instance():getStrValue(TableName.GatherResource, v.id, "resource_type")
      if tonumber(type) ~= resourceType then
        return false
      end
    end
  end
  return true
end

local function CheckIsInBuildRange(Ax, Ay, Bx, By, tileX, tileY)
  local rangePos = {}
  rangePos.x = Bx
  rangePos.y = By
  local list = BuildingUtils.GetAllNeighborsPos4(rangePos, tileX, tileY)
  if list ~= nil and 0 < #list then
    for k, v in pairs(list) do
      if v.x == Ax and v.y == Ay then
        return true
      end
    end
  end
  return false
end

local function GetResourcePercent(buildId, buildLv, endTime, startTime)
  local result = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildLv)
  if buildLevelTemplate ~= nil then
    local outSpeed = buildLevelTemplate:GetCollectSpeed() / 1000
    if 0 < outSpeed then
      local now = UITimeManager:GetInstance():GetServerTime()
      if 0 < endTime and endTime < now then
        now = endTime
      end
      local count = (now - startTime) * outSpeed
      local max = buildLevelTemplate:GetCollectMaxOthers()
      if count > max then
        count = max
      end
      result = count / max
    end
  end
  return result
end

local function GetCircleRange(tile)
  local x, y = math.modf((tile - 1) / 2)
  return x
end

local function CanMoveBuild(buildId)
  if buildId == BuildingTypes.FUN_BUILD_MAIN then
    return false
  end
  local gateBuilding = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_GATE)[1]
  if gateBuilding == nil or 1 > gateBuilding.level then
    return false
  end
  if buildId ~= nil then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if template ~= nil and not template:CanMove() then
      return false
    end
  end
  return true
end

local function IsClosePanel(buildId, level)
  local needMainLv = LuaEntry.DataConfig:TryGetNum("building_giftbox", "k1")
  if needMainLv >= DataCenter.BuildManager.MainLv then
    return true
  end
  local resourceType = DataCenter.BuildManager:GetOutResourceTypeByBuildId(buildId)
  if resourceType ~= ResourceType.None then
    if buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
      if LuaEntry.Effect:GetGameEffect(EffectDefine.UPGRADE_ADD_RES_CONDOMINIUM) == 0 then
        return false
      end
    elseif buildId == BuildingTypes.FUN_BUILD_WIND_TURBINE then
      if LuaEntry.Effect:GetGameEffect(EffectDefine.UPGRADE_ADD_RES_WIND) == 0 then
        return false
      end
    elseif buildId == BuildingTypes.FUN_BUILD_HERO_MONUMENT then
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if levelTemplate ~= nil then
        local talentId = levelTemplate:GetRewardNeedTalent()
        if 0 < talentId and not DataCenter.TalentDataManager:IsTalentOpen(talentId) then
          return false
        end
      end
    end
    return true
  end
  return false
end

local function IsRocketPlayingArrive(pointId)
  local result = false
  if CS.SceneManager.World ~= nil and CS.SceneManager.IsSceneBuildFninsh() == true then
    local city = CS.SceneManager.World:GetBuildingByPoint(pointId)
    if city ~= nil and city.transform:GetComponent(RocketType) ~= nil then
      cast(city, RocketType)
      if city:IsArriving() then
        result = true
      end
    end
  end
  return result
end

local function IsBuildingFunctioning(buildData)
  if buildData == nil then
    return false
  end
  return buildData.productStartTime ~= nil and buildData.productStartTime > 0
end

local function GetBuildilngFunctioningProgress(buildData)
  local hasWorker = true
  local progress = 0
  local totalTime = buildData.productEndTime - buildData.productStartTime
  if hasWorker then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now > buildData.productEndTime then
      now = buildData.productEndTime
    end
    local passTime = now - buildData.productTime + (buildData.productTime - buildData.productStartTime)
    progress = passTime / totalTime
  else
    local passTime = buildData.productTime - buildData.productStartTime
    progress = passTime / totalTime
  end
  return progress
end

local function IsBuildingFinishFunctioning(buildData)
  if buildData == nil or buildData.productStartTime == nil then
    return false
  end
  if buildData.productEndTime == nil then
    return false
  end
  local assignedHeroCount = true
  if assignedHeroCount then
    local now = UITimeManager:GetInstance():GetServerTime()
    return now >= buildData.productEndTime
  else
    if buildData.productTime == nil or buildData.productEndTime == nil then
      return false
    end
    return buildData.productTime >= buildData.productEndTime
  end
end

local function GetBuildingCurrentProduceCount(buildData)
  local count = 0
  local progress = BuildingUtils.GetBuildilngFunctioningProgress(buildData)
  count = count + progress * buildData.productBase
  return math.floor(count)
end

local function GetBuildingFunctioningRemainTime(buildData)
  local isTraining = BuildingUtils.IsBuildingFunctioning(buildData)
  local hasWorker = true
  if isTraining then
    if hasWorker then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now > buildData.productEndTime then
        now = buildData.productEndTime
      end
      return buildData.productEndTime - now
    else
      return buildData.productEndTime - buildData.productTime
    end
  end
  return 0
end

local function GetBuildingPredictedProduceCount(buildData)
  local count = 0
  count = count + buildData.productBase
  return math.floor(count)
end

local function GetBattleHangUpTime(buildData)
  if DataCenter.StageManager.lastIdleRewardTimeStamp then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
    return math.min(DataCenter.StageManager.hangUpMaxTime, timeDelta)
  end
  return 0
end

local function CollectSoldier(buildData)
  if buildData ~= nil and buildData.productEndTime ~= nil and buildData.productStartTime ~= nil then
    if buildData.itemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
      local trainCount = BuildingUtils.GetBuildingCurrentProduceCount(buildData)
      local storeLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK)
      if trainCount > math.modf(storeLimit) then
        UIUtil.ShowTipsId(120083)
        return
      end
      local curHaveCount = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
      if curHaveCount >= math.modf(storeLimit) then
        UIUtil.ShowTipsId(120083)
        return
      end
    end
    SFSNetwork.SendMessage(MsgDefines.BuildingCampCollect, buildData.uuid)
  end
end

local EquationType = {
  ResourceProduction = 1,
  BaseValueAddition = 2,
  tavern = 3,
  effect = 4,
  EffectAddition = 5,
  TavernAddition = 6,
  ProductLineInterval = 7,
  ProductionResItem = 8,
  EffectGlobal = 9,
  CustomFormula = 10
}
local GlobalEffect = {
  50107,
  50110,
  50130,
  50102,
  50103,
  50104,
  50114,
  50115,
  75053,
  75153,
  75253,
  75054,
  75154,
  75254,
  75055,
  75155,
  75255,
  94101,
  50139,
  50109,
  50131,
  50132,
  50148,
  50203,
  50061,
  50071,
  50209,
  50210,
  50211,
  50122,
  50123,
  50124
}

local function IsGlobalEffect(effectId)
  for i = 1, #GlobalEffect do
    if GlobalEffect[i] == effectId then
      return true
    end
  end
end

local function GetbuildPropertyData(buildData)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  local showDataList = string.split(buildLevelTemplate.bd_effect_result, "|")
  local propertyList = {}
  for i = 1, #showDataList do
    if showDataList[i] ~= "" then
      local temp = string.split(showDataList[i], ";")
      local data = {}
      data.type = tonumber(temp[2])
      data.effetType = tonumber(temp[1])
      data.effect = tonumber(temp[3]) or temp[3]
      table.insert(propertyList, data)
    end
  end
  return propertyList
end

local function GetEffectValueById(effect)
  local effectValue = LuaEntry.Effect:GetGameEffect(effect) or 0
  if effect == EffectDefine.Food_Produce_Add_50023 or effect == EffectDefine.Iron_Produce_Add_50024 or effect == EffectDefine.Gold_Produce_Add_50101 then
    effectValue = effectValue + SeasonUtil.GetSeasonBuffValue(effect)
  end
  return effectValue
end

local function GetCustomFormulaValue(effect, buildData)
  if type(effect) ~= "string" then
    Logger.Log("Invalid effect:not string")
    return 0
  end
  if string.len(effect) > 50 then
    Logger.Log("Invalid effect:too long, over 50")
    return 0
  end
  if effect:match("[^%d%%+%-%*/%(%)%s]") then
    Logger.Log("Invalid effect: Only digits, %, +, -, *, /, (, ) are allowed.")
    return 0
  end
  local balance = 0
  for char in effect:gmatch(".") do
    if char == "(" then
      balance = balance + 1
    elseif char == ")" then
      balance = balance - 1
    end
  end
  if balance ~= 0 then
    Logger.Log("Invalid effect: Mismatched parentheses.")
    return 0
  end
  
  local function GetEffectNumber(effectNum)
    local effectValue = GetEffectValueById(effectNum)
    local workerEffectValue = IsGlobalEffect(effectNum) and 0 or DataCenter.WorkerDataManager:GetWorkerAddition(buildData.uuid, effectNum)
    return effectValue + workerEffectValue
  end
  
  local processedExpression = effect:gsub("%%(%d+)", function(number)
    return tostring(GetEffectNumber(tonumber(number)))
  end)
  local result, err = load("return " .. processedExpression)
  if not result then
    Logger.Log("Error evaluating expression: " .. err)
    return 0
  end
  return result()
end

local function GetPropertyValueByType(buildData, type, effect)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  local value = 0
  local effectValue = GetEffectValueById(effect)
  local workerEffectValue = IsGlobalEffect(effect) and 0 or DataCenter.WorkerDataManager:GetWorkerAddition(buildData.uuid, effect)
  local para1 = tonumber(buildLevelTemplate.para1 and buildLevelTemplate.para1 or 0) or 0
  if type == EquationType.ResourceProduction then
    local consume = string.split(buildLevelTemplate.pgcStr, ";")
    consume = 1 < #consume and tonumber(consume[2]) or 0
    value = consume * 720 * (1 + effectValue + workerEffectValue)
  elseif type == EquationType.BaseValueAddition then
    value = para1 + effectValue + workerEffectValue
  elseif type == EquationType.tavern then
    value = para1 - effectValue - workerEffectValue
  elseif type == EquationType.effect then
    value = effectValue + workerEffectValue
  elseif type == EquationType.EffectAddition then
    local showDataList = string.split(buildLevelTemplate.effect_last, "|")
    local temp = string.split(showDataList[1], ";")
    local effectLastValue = temp[2]
    value = effectLastValue * (1 + effectValue + workerEffectValue)
  elseif type == EquationType.TavernAddition then
    value = para1 * (1 + effectValue + workerEffectValue)
  elseif type == EquationType.ProductLineInterval then
    value = table.values(buildLevelTemplate.produce_gain_resource)[1] * (3600000 / buildLevelTemplate.produce_time) * (1 + effectValue)
  elseif type == EquationType.ProductionResItem then
    value = buildLevelTemplate.produce_time / 1000
  elseif type == EquationType.EffectGlobal then
    value = effectValue
  end
  return value
end

local function GetPropertyValueByEffectList(buildData, effectList)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  local value = 0
  local para1 = tonumber(buildLevelTemplate.para1 and buildLevelTemplate.para1 or 0) or 0
  for i = 1, #effectList do
    local type = effectList[i].type
    local effect = effectList[i].effect
    if i == 1 then
      if type == EquationType.CustomFormula then
        return GetCustomFormulaValue(effect, buildData)
      end
      value = GetPropertyValueByType(buildData, type, effect)
    else
      local effectValue = GetEffectValueById(effect) or 0
      local workerEffectValue = IsGlobalEffect(effect) and 0 or DataCenter.WorkerDataManager:GetWorkerAddition(buildData.uuid, effect)
      if type == EquationType.ResourceProduction then
        local consume = string.split(buildLevelTemplate.pgcStr, ";")
        consume = 1 < #consume and tonumber(consume[2]) or 0
        value = consume * 720 * (1 + effectValue + workerEffectValue)
      elseif type == EquationType.BaseValueAddition then
        value = value + effectValue + workerEffectValue
      elseif type == EquationType.tavern then
        value = value - effectValue - workerEffectValue
      elseif type == EquationType.effect then
        value = effectValue + workerEffectValue
      elseif type == EquationType.EffectAddition then
        local showDataList = string.split(buildLevelTemplate.effect_last, "|")
        local temp = string.split(showDataList[1], ";")
        local effectLastValue = temp[2]
        value = effectLastValue * (1 + effectValue + workerEffectValue)
      elseif type == EquationType.TavernAddition then
        value = value * (1 + effectValue + workerEffectValue)
      elseif type == EquationType.ProductLineInterval then
        value = table.values(buildLevelTemplate.produce_gain_resource)[1] * (3600000 / buildLevelTemplate.produce_time) * (1 + effectValue)
      elseif type == EquationType.ProductionResItem then
        value = buildLevelTemplate.produce_time / 1000
      elseif type == EquationType.EffectGlobal then
        value = effectValue
      end
    end
  end
  return value
end

local function GetBuildingPropertyDataList(buildData)
  local propertyList = GetbuildPropertyData(buildData)
  local tempValue = 0
  local propertyData = {}
  local propertyDataList = {}
  if #propertyList == 0 then
    return
  end
  local showTypeEffectIdList = {}
  local showTypeEffectIdDict = {}
  for i = 1, #propertyList do
    local effetType = propertyList[i].effetType
    if showTypeEffectIdDict[effetType] == nil then
      local count = #showTypeEffectIdList
      local index = count + 1
      showTypeEffectIdList[index] = effetType
      showTypeEffectIdDict[effetType] = {
        index = index,
        effectList = {}
      }
    end
    local type = propertyList[i].type
    local effect = propertyList[i].effect
    table.insert(showTypeEffectIdDict[effetType].effectList, {type = type, effect = effect})
  end
  for i = 1, #showTypeEffectIdList do
    local effetType = showTypeEffectIdList[i]
    local effectData = showTypeEffectIdDict[effetType]
    propertyData = {}
    tempValue = GetPropertyValueByEffectList(buildData, effectData.effectList)
    propertyData.describe, propertyData.valueText = WorkerUtil.GetEffectText(effetType, tempValue, true)
    propertyData.iconPath = GetTableData(TableName.LW_Effect_Number, effetType, "icon")
    propertyData.effectId = effetType
    table.insert(propertyDataList, propertyData)
  end
  return propertyDataList
end

local function GetCityBuildAllResByItemId(itemId)
  if itemId == nil then
    return
  end
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(itemId)
  local allStorage = 0
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    return
  end
  local totalStorage = 0
  for k, v in pairs(buildList) do
    local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
    totalStorage = totalStorage + storage
  end
  if 0 < totalStorage then
    for k, v in pairs(buildList) do
      local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
      allStorage = storage + allStorage
    end
  end
  return allStorage
end

local function CityCollectionByItemId(itemId, origin_pos, target_pos, time)
  if itemId == nil then
    return
  end
  local buildList = BuildingUtils.GetBuildListByBuildId(itemId)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local totalStorage = 0
  local startTime = 0
  local tempTime = 0
  local skipIt = false
  for k, v in pairs(buildList) do
    skipIt = false
    if BuildingUtils.IsSeasonWeekCardCityBuilding(v.itemId) then
      local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
      if curTime >= settleTime then
        skipIt = true
      end
    end
    if skipIt ~= true then
      startTime = v.productStartTime and v.productStartTime or curTime
      tempTime = (curTime - startTime) / 1000
      if time and time < tempTime or not time then
        local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
        local count = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
        if 0 < storage and 0 < count then
          DataCenter.ProductLineManager:SendCollect(v.uuid)
          totalStorage = totalStorage + storage
        end
      end
    end
  end
  if 0 < totalStorage and origin_pos and target_pos and 0 < totalStorage then
    local icon
    local resType = table.keys(DataCenter.ProductLineManager:GetProductRes(buildList[1].uuid))[1]
    if resType then
      icon = DataCenter.ResourceManager:GetResourceIconByType(resType)
    end
    if resType == nil then
      resType = table.keys(DataCenter.ProductLineManager:GetProductResItem(buildList[1].uuid))[1]
      if resType then
        icon = DataCenter.ResourceItemDataManager:GetIconPath(resType)
      end
    end
    if resType == nil then
      resType = table.keys(DataCenter.ProductLineManager:GetProductGoods(buildList[1].uuid))[1]
      if resType then
        icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, resType)
      end
    end
    if icon then
      UIUtil.DoFly(ResourceType.None, 5, icon, origin_pos, target_pos, 84, 78, nil, false, 0.8, 1.0, nil)
    end
  else
  end
  return totalStorage
end

local function BuildDoFlyMainUI(bUuid, mainUIType)
end

local function GetCityBuildingModelName(buildId, buildLevel, useDefault)
  local result = ""
  if buildId == BuildingTypes.FUN_BUILD_MAIN and not useDefault then
    result = DataCenter.DecorationDataManager:GetCityBuildingDecoration()
  end
  if result == nil or result == "" then
    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildLevel)
    if template ~= nil then
      result = template:GetCityModelName()
    end
  end
  return result
end

local function GetWorldBuildingModelName(buildId, buildLevel, useDefault)
  local result = ""
  if buildId == BuildingTypes.FUN_BUILD_MAIN then
    if not useDefault then
      result = DataCenter.DecorationDataManager:GetWorldBuildingDecoration()
    end
    if buildLevel == nil then
      local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
      if mainBuild and mainBuild.level then
        buildLevel = mainBuild.level
      end
    end
  end
  if result == nil or result == "" then
    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildLevel)
    if template ~= nil then
      result = template:GetWorldModelName()
    end
  end
  return result
end

local function IsInEdenSubwayGroup(buildId)
  if buildId == BuildingTypes.EDEN_WORM_HOLE_1 or buildId == BuildingTypes.EDEN_WORM_HOLE_2 or buildId == BuildingTypes.EDEN_WORM_HOLE_3 then
    return true
  end
  return false
end

local qualityColor = {
  "<color=#FFFFFF>%s</color>",
  "<color=#B5FFA7>%s</color>",
  "<color=#8BF5FF>%s</color>",
  "<color=#EB86FF>%s</color>",
  "<color=#FFB644>%s</color>"
}

local function GetDecorateColor(id, isGetNumber)
  local quality = 1
  if not id or id == "" then
    return isGetNumber and quality or qualityColor[quality]
  end
  local char4 = string.sub(id, 4, 4)
  quality = tonumber(char4)
  quality = quality or 1
  if isGetNumber then
    return quality
  else
    return qualityColor[quality] or qualityColor[1]
  end
end

local function GetDecorateUpLevelList(buildData)
  local isNotInclude
  if buildData.state == BuildingStateType.FoldUp then
    isNotInclude = true
  end
  local tempDic = {}
  local buildLevel = buildData.level
  local useNewCountLogic = false
  if DataCenter.BuildManager:UseNewDecorationCountLogic() then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
    if buildTemplate ~= nil and buildTemplate.max_level > 1 then
      useNewCountLogic = true
    end
  end
  
  local function CollectData(data)
    if data.level <= buildLevel then
      local tempId = data.itemId + data.level
      if useNewCountLogic then
        if tempDic[tempId] == nil then
          tempDic[tempId] = {
            buildData = data,
            id = tempId,
            count = BuildingUtils.GetDecorateCountByLevel(data.itemId, data.level)
          }
        end
      else
        local _tempDic = tempDic
        local _val = _tempDic[tempId]
        if _val then
          _val.count = _val.count + 1
        else
          _tempDic[tempId] = {
            buildData = data,
            id = tempId,
            count = 1
          }
        end
      end
    end
  end
  
  DataCenter.BuildManager:DoActionForAllBuilding(buildData.itemId, BuildingStateType.FoldUp, CollectData)
  if isNotInclude then
    local temp = tempDic[buildData.itemId + buildData.level]
    if temp then
      temp.count = temp.count - 1
    end
  end
  local list = {}
  for i, v in pairs(tempDic) do
    list[#list + 1] = v
  end
  table.sort(list, function(a, b)
    if a.buildData.level > b.buildData.level then
      return true
    end
  end)
  return list
end

local function GetDecorateCountByLevel(itemId, level)
  local useNewCountLogic = false
  if DataCenter.BuildManager:UseNewDecorationCountLogic() then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
    if buildTemplate ~= nil and buildTemplate.max_level > 1 then
      useNewCountLogic = true
    end
  end
  local dataList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(itemId)
  local count = 0
  if dataList then
    for i = 1, #dataList do
      if dataList[i].level == level then
        if useNewCountLogic then
          local decorNum = dataList[i]:GetDecorNum()
          if decorNum ~= -1 then
            count = decorNum
            break
          end
        end
        count = count + 1
      end
    end
  end
  return count
end

local function GetDecorateUpLevelBuilds(buildData)
  local list = GetDecorateUpLevelList(buildData)
  local dic = {}
  local data, curScore, param, temp
  local buildTemplateManager = DataCenter.BuildTemplateManager
  local levelTemplate = buildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  local nextScore = tonumber(levelTemplate.para2)
  if not nextScore then
    return
  end
  local math_min = math.min
  local math_floor = math.floor
  for i = 1, #list do
    data = list[i]
    temp = buildTemplateManager:GetBuildingLevelTemplate(data.buildData.itemId, data.buildData.level)
    curScore = tonumber(temp.para1)
    if nextScore >= curScore and data.count ~= nil and data.count > 0 then
      param = {}
      local count = math_min(math_floor(nextScore / curScore), data.count)
      nextScore = nextScore - count * curScore
      param.count = count
      param.levelTemplate = temp
      param.buildData = data.buildData
      param.id = temp.id
      param.itemId = temp.id
      dic[#dic + 1] = param
    end
  end
  if 0 < nextScore then
    param = {}
    temp = buildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 1)
    if dic and 0 < #dic and dic[#dic].id == temp.id then
      dic[#dic].needScore = nextScore
      dic[#dic].nextScore = nextScore + dic[#dic].count
      return dic
    end
    param.levelTemplate = temp
    param.id = temp.id
    param.count = 0
    param.nextScore = nextScore
    param.needScore = nextScore
    dic[#dic + 1] = param
  end
  return dic
end

function BuildingUtils.GetBuildHp(curHp, lstHpTime, fireEndTime, recoverSpeed, fireSpeed)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local intervalTimeSec = curTime - lstHpTime
  local maxFireTimeSec = fireEndTime - lstHpTime
  local fireTimeSec = math.min(math.max(maxFireTimeSec, 0), intervalTimeSec)
  local normalTimeSec = intervalTimeSec - fireTimeSec
  if 0 < fireTimeSec then
    if fireSpeed == nil or fireSpeed == 0 then
      fireSpeed = tonumber(GetTableData(TableName.StatusTab, 500300, "effect_num"))
    end
    curHp = math.max(curHp - fireTimeSec * fireSpeed, 1)
  end
  if 0 < normalTimeSec then
    if recoverSpeed == nil or recoverSpeed == 0 then
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
      recoverSpeed = buildLevelTemplate:GetDefenceWallCoverSpeed()
    end
    curHp = curHp + normalTimeSec * recoverSpeed
  end
  return curHp
end

function BuildingUtils.IsDecoratorCantBuyDirectly(baseBuildingId)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  if not table.IsNullOrEmpty(template.direct_exchange) then
    for k, v in ipairs(template.direct_exchange) do
      local giftPackList = GiftPackageData.GetAllAvailablePackageByRechargeId(v, false)
      if not table.IsNullOrEmpty(giftPackList) then
        return false
      end
    end
  end
  return true
end

function BuildingUtils.IsAllGluePackageGroupIdSoldOut(baseBuildingId)
  local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  if not table.IsNullOrEmpty(desTemplate.glue_exchange_id) then
    for k, v in pairs(desTemplate.glue_exchange_id) do
      local packs = GiftPackManager.GetPacksByGroupId(v, false)
      if not table.IsNullOrEmpty(packs) then
        return false
      end
    end
  end
  return true
end

function BuildingUtils.GetDecoratorAvailableRechargeId(baseBuildingId)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  if not table.IsNullOrEmpty(template.direct_exchange) then
    for k, v in ipairs(template.direct_exchange) do
      local giftPackList = GiftPackageData.GetAllAvailablePackageByRechargeId(v, false)
      if not table.IsNullOrEmpty(giftPackList) then
        return v
      end
    end
  end
end

function BuildingUtils.GetDecoratorBookBg(quality)
  if quality == 5 then
    return "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_tujian_card.png"
  elseif quality == 4 then
    return "Assets/Main/Sprites/UI/LWDecorationBook/lrb_zhuagnshiwugongfang_tujian_card_zi.png"
  elseif quality == 3 then
    return "Assets/Main/Sprites/UI/LWDecorationBook/lrb_zhuagnshiwugongfang_tujian_card_lan.png"
  end
end

function BuildingUtils.GetBuildListByBuildId(buildId)
  local buildList
  if BuildingUtils.IsSeasonInCityBuilding(buildId) then
    buildList = BuildingUtils.GetSeasonBuildingGroupByType(buildId)
  else
    buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  end
  return buildList
end

local function IsShowBlackMarketBuilding(buildData)
  local _activeActId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.BlackMarket.Type)
  if _activeActId then
    return BuildingStateType.Normal
  end
  return BuildingStateType.FoldUp
end

local ConditionBuildingTypes = {}
ConditionBuildingTypes[BuildingTypes.LW_BUILD_BLACKMARKET] = IsShowBlackMarketBuilding

function BuildingUtils.GetConditionBuildingState(buildData)
  local _type = buildData.itemId
  local _func = ConditionBuildingTypes[_type]
  if _func then
    return _func(buildData)
  end
  return buildData.state
end

function BuildingUtils.IsBuildMaxLevel(buildTemplate, buildingLvTemplate)
  local isMaxLevel = false
  if buildTemplate and buildingLvTemplate then
    if buildingLvTemplate.level >= buildTemplate.max_level then
      isMaxLevel = true
    elseif not buildingLvTemplate:IsTimeConditionValid() then
      isMaxLevel = true
    end
  end
  return isMaxLevel
end

function BuildingUtils.GetRemainProgressToNextStage(groupId, level, progress)
  local curProgressTmp = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, level, progress, true)
  if not curProgressTmp then
    return nil
  end
  return curProgressTmp.stage_need - progress
end

function BuildingUtils.GetRemainProgressToNextLevel(groupId, level, progress)
  local curLvMaxProgressTmp = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, level)
  if not curLvMaxProgressTmp then
    return nil
  end
  return curLvMaxProgressTmp.stage_need - progress
end

function BuildingUtils.GetDecorationProgressUpValue(buildingId, fromLevel, fromProgress, toLevel, toProgress)
  local paramList = {}
  local temp, temp1
  local curProgressEffInfo = BuildingUtils.GetDecorationProgressEffectInfo(buildingId, fromLevel, fromProgress)
  local nextProgressEffInfo = BuildingUtils.GetDecorationProgressEffectInfo(buildingId, toLevel, toProgress)
  for effId, effVal in pairs(nextProgressEffInfo) do
    local isNewProp = not table.containsKey(curProgressEffInfo, effId)
    local param = {}
    param.isNew = isNewProp
    temp, temp1 = WorkerUtil.GetEffectText(effId, effVal, true)
    param.name = temp
    param.addValue = temp1
    param.effectId = effId
    if isNewProp then
      param.curValue = 0
      param.changeNumVal = effVal
    else
      temp, temp1 = WorkerUtil.GetEffectText(effId, curProgressEffInfo[effId], true)
      param.curValue = temp1
      param.changeNumVal = effVal - curProgressEffInfo[effId]
    end
    table.insert(paramList, param)
  end
  return paramList
end

function BuildingUtils.GetDecorationProgressEffectInfo(buildingId, level, targetProgress)
  local ret = {}
  local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, level)
  if not curLevelTemplate then
    return nil
  end
  local groupId = curLevelTemplate.decoGroupUpgradeBaseId
  local upgradeInfo
  if groupId and 0 < groupId then
    upgradeInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, level, targetProgress, false)
  end
  local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, level)
  local buildBaseEffList, progressEffList, starEffList
  if levelTemplate then
    buildBaseEffList = levelTemplate.building_effect_last
  end
  if upgradeInfo then
    progressEffList = upgradeInfo:GetBaseEffectFromProgress(targetProgress)
    starEffList = upgradeInfo:GetEffectFromStarByProgress(targetProgress)
  end
  for effId, effVal in pairs(buildBaseEffList) do
    if not table.containsKey(ret, effId) then
      ret[effId] = effVal
    else
      ret[effId] = ret[effId] + effVal
    end
  end
  if progressEffList then
    for effId, effVal in pairs(progressEffList) do
      if not table.containsKey(ret, effId) then
        ret[effId] = effVal
      else
        ret[effId] = ret[effId] + effVal
      end
    end
  end
  if starEffList then
    for effId, effVal in pairs(starEffList) do
      if not table.containsKey(ret, effId) then
        ret[effId] = effVal
      else
        ret[effId] = ret[effId] + effVal
      end
    end
  end
  return ret
end

function BuildingUtils.IsExistAdvanceUpgrade(buildingId, level)
  local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, level)
  if not curLevelTemplate then
    return false
  end
  local groupId = curLevelTemplate.decoGroupUpgradeBaseId or 0
  return 0 < groupId
end

function BuildingUtils.GetDecoProgressInfo(buildingId, level)
  local progress = 0
  local maxProgress = 0
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildingId, true)
  if not buildData then
    return progress, maxProgress
  end
  local isAdvanceUpgrade = BuildingUtils.IsExistAdvanceUpgrade(buildingId, level)
  local hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildData.itemId, buildData.level, false)
  if not isAdvanceUpgrade then
    local upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(buildData)
    if upLevelScarceInfos and 0 < table.count(upLevelScarceInfos) then
      local lastData = upLevelScarceInfos[#upLevelScarceInfos]
      local isLack = lastData.nextScore
      local displayUpLevelScarceInfos = {}
      local param = {}
      param.count = 0
      if isLack then
        param.nextScore = 0
      end
      for k, v in pairs(upLevelScarceInfos) do
        if isLack then
          if v.nextScore then
            param.count = param.count + v.count
            param.nextScore = param.nextScore + v.nextScore
          else
            param.count = param.count + v.count * v.levelTemplate.para1
            param.nextScore = param.nextScore + v.count * v.levelTemplate.para1
          end
        else
          param.count = param.count + v.count * v.levelTemplate.para1
        end
      end
      table.insert(displayUpLevelScarceInfos, param)
      progress = displayUpLevelScarceInfos[1].count
      maxProgress = displayUpLevelScarceInfos[1].nextScore
      if not maxProgress then
        maxProgress = progress
      end
    end
  else
    local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    if not (lvTemplate and lvTemplate.decoGroupUpgradeBaseId) or 0 > lvTemplate.decoGroupUpgradeBaseId then
      return progress, maxProgress
    end
    local groupId = lvTemplate.decoGroupUpgradeBaseId
    local maxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, buildData.level)
    if not maxProgressInfo then
      return progress, maxProgress
    end
    progress = buildData.prodStatus or 0
    maxProgress = maxProgressInfo.stage_need
  end
  return progress, maxProgress
end

function BuildingUtils.GetEffectFromBuildings(effects)
  local vals = {}
  local allBuildingData = DataCenter.BuildManager:GetAllBuildData()
  if allBuildingData then
    for uuid, buildingData in pairs(allBuildingData) do
      if buildingData.state ~= BuildingStateType.FoldUp then
        local meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, buildingData.level)
        if meta and meta.tab_type ~= UIBuildListTabType.Decorate and meta.building_effect_last then
          for effectId, effectValue in pairs(meta.building_effect_last) do
            if effects[effectId] then
              if not vals[effectId] then
                vals[effectId] = 0
              end
              vals[effectId] = vals[effectId] + effectValue
            end
          end
        end
      end
    end
  end
  return vals
end

function BuildingUtils.GetEffectFromDecorations(effects)
  local vals = {}
  local allDecorate = DataCenter.BuildManager:GetAllDecoratorBuildingData()
  for buildBaseId, list in pairs(allDecorate) do
    for k, v in pairs(list) do
      if v.state == BuildingStateType.Normal then
        local buildingId = v.itemId
        local level = v.level
        local progress = v.prodStatus or 0
        local effectList = BuildingUtils.GetDecorationProgressEffectInfo(buildingId, level, progress)
        if effectList then
          for effectId, effectValue in pairs(effectList) do
            if effects[effectId] then
              if not vals[effectId] then
                vals[effectId] = 0
              end
              vals[effectId] = vals[effectId] + effectValue
            end
          end
        end
      end
    end
  end
  return vals
end

local flagPositionRange

function BuildingUtils.IsInFlagPosition(index)
  if flagPositionRange == nil then
    flagPositionRange = {
      [5049] = true,
      [5050] = true,
      [4950] = true,
      [4949] = true
    }
  end
  return flagPositionRange[index] == true
end

BuildingUtils.GetTrainingTypeAndBuildingType = GetTrainingTypeAndBuildingType
BuildingUtils.GetMainPos = GetMainPos
BuildingUtils.GetAllNeighborsPosCenter = GetAllNeighborsPosCenter
BuildingUtils.GetAllNeighborsPos4 = GetAllNeighborsPos4
BuildingUtils.GetAllNeighborsPos = GetAllNeighborsPos
BuildingUtils.GetBuildTileIndex = GetBuildTileIndex
BuildingUtils.IsCanPutDownByBuild = IsCanPutDownByBuild
BuildingUtils.IsCanPutDownByPoint = IsCanPutDownByPoint
BuildingUtils.IsCanPutDownBoardByPoint = IsCanPutDownBoardByPoint
BuildingUtils.IsCanPutDownInWorldByPoint = IsCanPutDownInWorldByPoint
BuildingUtils.IsCanShowCollectGreenByPoint = IsCanShowCollectGreenByPoint
BuildingUtils.IsInRangeBySquare = IsInRangeBySquare
BuildingUtils.IsOutOtherBaseSquareRange = IsOutOtherBaseSquareRange
BuildingUtils.IsInMyBaseCircleRange = IsInMyBaseCircleRange
BuildingUtils.IsInMainSubRange = IsInMainSubRange
BuildingUtils.ShowPutBuild = ShowPutBuild
BuildingUtils.ShowPutAllianceBuild = ShowPutAllianceBuild
BuildingUtils.GetAllPointsByCircle = GetAllPointsByCircle
BuildingUtils.GetAllPointsBySquare = GetAllPointsBySquare
BuildingUtils.GetOutermostIndexByIndex = GetOutermostIndexByIndex
BuildingUtils.GetPointByBuildCanPut = GetPointByBuildCanPut
BuildingUtils.GetSaveBuildPlaceTypePoint = GetSaveBuildPlaceTypePoint
BuildingUtils.GetBuildRangePoint = GetBuildRangePoint
BuildingUtils.GetNearestCanPlaceRoadRangePoint = GetNearestCanPlaceRoadRangePoint
BuildingUtils.GetSecondBuildCanPlacePoint = GetSecondBuildCanPlacePoint
BuildingUtils.GetPlaceDirectionByMainBuild = GetPlaceDirectionByMainBuild
BuildingUtils.IsCanBuildNext = IsCanBuildNext
BuildingUtils.GetBuildModelCenter = GetBuildModelCenter
BuildingUtils.GetBuildModelCenterVec = GetBuildModelCenterVec
BuildingUtils.GetAllCanPutPointsByBuildId = GetAllCanPutPointsByBuildId
BuildingUtils.IsInMyBaseSquareRange = IsInMyBaseSquareRange
BuildingUtils.IsBuildResourceEmpty = IsBuildResourceEmpty
BuildingUtils.CheckIsInBuildRange = CheckIsInBuildRange
BuildingUtils.GetResourcePercent = GetResourcePercent
BuildingUtils.GetCircleRange = GetCircleRange
BuildingUtils.GetBuildRoundPos = GetBuildRoundPos
BuildingUtils.CanMoveBuild = CanMoveBuild
BuildingUtils.GetBuildModelDownVec = GetBuildModelDownVec
BuildingUtils.IsClosePanel = IsClosePanel
BuildingUtils.IsRocketPlayingArrive = IsRocketPlayingArrive
BuildingUtils.GetBuildMainVecByModelCenter = GetBuildMainVecByModelCenter
BuildingUtils.IsBuildingFunctioning = IsBuildingFunctioning
BuildingUtils.GetBuildilngFunctioningProgress = GetBuildilngFunctioningProgress
BuildingUtils.IsBuildingFinishFunctioning = IsBuildingFinishFunctioning
BuildingUtils.GetBuildingCurrentProduceCount = GetBuildingCurrentProduceCount
BuildingUtils.GetBuildingFunctioningRemainTime = GetBuildingFunctioningRemainTime
BuildingUtils.GetBuildingPredictedProduceCount = GetBuildingPredictedProduceCount
BuildingUtils.GetBattleHangUpTime = GetBattleHangUpTime
BuildingUtils.CollectSoldier = CollectSoldier
BuildingUtils.GetBuildingPropertyDataList = GetBuildingPropertyDataList
BuildingUtils.GetPropertyValueByType = GetPropertyValueByType
BuildingUtils.GetbuildPropertyData = GetbuildPropertyData
BuildingUtils.CityCollectionByItemId = CityCollectionByItemId
BuildingUtils.GetCityBuildAllResByItemId = GetCityBuildAllResByItemId
BuildingUtils.BuildDoFlyMainUI = BuildDoFlyMainUI
BuildingUtils.GetCityBuildingModelName = GetCityBuildingModelName
BuildingUtils.GetWorldBuildingModelName = GetWorldBuildingModelName
BuildingUtils.CanPutDownWithMarch = CanPutDownWithMarch
BuildingUtils.GetDecorateColor = GetDecorateColor
BuildingUtils.GetDecorateUpLevelBuilds = GetDecorateUpLevelBuilds
BuildingUtils.IsInEdenSubwayGroup = IsInEdenSubwayGroup
BuildingUtils.GetDecorateCountByLevel = GetDecorateCountByLevel
BuildingUtils.IsSeasonInCityBuilding = IsSeasonInCityBuilding
BuildingUtils.GetSeasonBuildingGroupByType = GetSeasonBuildingGroupByType
BuildingUtils.CheckIgnoreRangeLimit = CheckIgnoreRangeLimit
BuildingUtils.IsSeasonWeekCardCityBuilding = IsSeasonWeekCardCityBuilding
return ConstClass("BuildingUtils", BuildingUtils)
