local SceneUtils = {}
local isInCityScene = false
local Resource = CS.GameEntry.Resource
local SVC_CITY_PATH = "Assets/Main/Shaders2019/SVC_City.shadervariants"
local SVC_WORLD_PATH = "Assets/Main/Shaders2019/SVC_World.shadervariants"
local NinePalacesWorldBasePosX = {
  0,
  2000,
  4000,
  0,
  2000,
  4000,
  0,
  2000,
  4000
}
local NinePalacesWorldBasePosZ = {
  0,
  0,
  0,
  2000,
  2000,
  2000,
  4000,
  4000,
  4000
}
local NinePalacesTileBasePosX = {
  0,
  1000,
  2000,
  0,
  1000,
  2000,
  0,
  1000,
  2000
}
local NinePalacesTileBasePosZ = {
  0,
  0,
  0,
  1000,
  1000,
  1000,
  2000,
  2000,
  2000
}
local _tile_v2_pool = setmetatable({}, {__mode = "k"})
local _tile_v3_pool = setmetatable({}, {__mode = "k"})
local socket = require("socket")
local usePool

local function _NewV2()
  if nil == usePool then
    SceneUtils.RefreshUsePool()
  end
  if usePool then
    local v2
    for vec, _ in pairs(_tile_v2_pool) do
      v2 = vec
      break
    end
    if v2 then
      _tile_v2_pool[v2] = nil
      return v2
    end
  end
  return {x = 0, y = 0}
end

local function ReturnPoolV2(v2)
  if nil == usePool then
    SceneUtils.RefreshUsePool()
  end
  if usePool then
    v2.x = 0
    v2.y = 0
    _tile_v2_pool[v2] = true
  end
end

local function _NewV3()
  if nil == usePool then
    SceneUtils.RefreshUsePool()
  end
  if usePool then
    local v3
    for vec, _ in pairs(_tile_v3_pool) do
      v3 = vec
      break
    end
    if v3 then
      _tile_v3_pool[v3] = nil
      return v3
    end
  end
  return {
    x = 0,
    y = 0,
    z = 0
  }
end

local function ReturnPoolV3(v3)
  if nil == usePool then
    SceneUtils.RefreshUsePool()
  end
  if usePool then
    v3.x = 0
    v3.y = 0
    v3.z = 0
    _tile_v3_pool[v3] = true
  end
end

function SceneUtils.RefreshUsePool()
  if LuaEntry and LuaEntry.Player then
    usePool = LuaEntry.Player:IsOpenReturnOpt()
  end
end

local function SetIsInCity(value)
  isInCityScene = value
end

function SceneUtils.GetNinePalacesOffsetByIndex(mapIndex)
  return NinePalacesWorldBasePosX[mapIndex], 0, NinePalacesWorldBasePosZ[mapIndex]
end

function SceneUtils.GetNinePalacesOffset(theServerId)
  local serverId = toInt(theServerId)
  if 0 < serverId then
    local info = SeasonUtil.GetSeasonInfo(serverId)
    if info ~= nil and info:GetServerType() == SeasonMapType.NineNation then
      local mapIndex = info:GetNinePalacesIndex(serverId)
      if 1 < mapIndex then
        return NinePalacesWorldBasePosX[mapIndex], 0, NinePalacesWorldBasePosZ[mapIndex]
      end
    end
  end
  return 0, 0, 0
end

local function TileToWorld(tilePos, forceType, theServerId)
  local v3 = _NewV3()
  v3.x = (tilePos.x + 0.5) * TileSize
  v3.y = 0
  v3.z = (tilePos.y + 0.5) * TileSize
  if forceType == ForceChangeScene.World and theServerId ~= nil and theServerId ~= 0 then
    local x, y, z = SceneUtils.GetNinePalacesOffset(theServerId)
    if x ~= nil and z ~= nil then
      v3.x = v3.x + x
      v3.z = v3.z + z
    end
  end
  return v3
end

function SceneUtils.TileToUniqueTile(tilePos, serverId)
  local v2 = {
    x = tilePos.x,
    y = tilePos.y
  }
  if serverId ~= nil and serverId ~= 0 then
    local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(serverId)
    if 1 < mapIndex then
      v2.x = tilePos.x + NinePalacesTileBasePosX[mapIndex]
      v2.y = tilePos.y + NinePalacesTileBasePosZ[mapIndex]
    end
  end
  return v2
end

function SceneUtils.WorldToUniqueTile(worldPos)
  local v2 = _NewV2()
  v2.x = math.floor(worldPos.x / TileSize)
  v2.y = math.floor(worldPos.z / TileSize)
  return v2
end

function SceneUtils.UniqueTileToWorld(uniqueTile)
  return SceneUtils.TileToWorld(uniqueTile)
end

function SceneUtils.WorldXYToUniqueTileXY(x, y)
  return math.floor(x / TileSize), math.floor(y / TileSize)
end

local function WorldToTileFloat(worldPos)
  local v2 = _NewV2()
  if SeasonUtil.GetSeasonType() == SeasonMapType.NineNation then
    v2.x = Mathf.Mod(worldPos.x / TileSize, WORLD_TILE_COUNT_MAX) - 0.5
    v2.y = Mathf.Mod(worldPos.z / TileSize, WORLD_TILE_COUNT_MAX) - 0.5
  else
    v2.x = worldPos.x / TileSize - 0.5
    v2.y = worldPos.z / TileSize - 0.5
  end
  return v2
end

local function WorldToTileFloatXY(worldPos)
  local x = 0
  local y = 0
  if SeasonUtil.GetSeasonType() == SeasonMapType.NineNation then
    x = math.floor((Mathf.Mod(worldPos.x / TileSize, WORLD_TILE_COUNT_MAX) - 0.5) * 100) / 100
    y = math.floor((Mathf.Mod(worldPos.z / TileSize, WORLD_TILE_COUNT_MAX) - 0.5) * 100) / 100
  else
    x = math.floor((worldPos.x / TileSize - 0.5) * 100) / 100
    y = math.floor((worldPos.z / TileSize - 0.5) * 100) / 100
  end
  return x, y
end

local function WorldToTile(worldPos)
  local v2 = _NewV2()
  if SeasonUtil.GetSeasonType() == SeasonMapType.NineNation then
    v2.x = Mathf.Mod(math.floor(worldPos.x / TileSize), WORLD_TILE_COUNT_MAX)
    v2.y = Mathf.Mod(math.floor(worldPos.z / TileSize), WORLD_TILE_COUNT_MAX)
  else
    v2.x = math.floor(worldPos.x / TileSize)
    v2.y = math.floor(worldPos.z / TileSize)
  end
  return v2
end

local function WorldToTileXZ(x, z)
  if SeasonUtil.GetSeasonType() == SeasonMapType.NineNation then
    x = Mathf.Mod(math.floor(x / TileSize), WORLD_TILE_COUNT_MAX)
    z = Mathf.Mod(math.floor(z / TileSize), WORLD_TILE_COUNT_MAX)
  else
    x = math.floor(x / TileSize)
    z = math.floor(z / TileSize)
  end
  return x, z
end

local function TileDistanceToMyHome(pointIndex, serverId)
  local myCityPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  local targetPos = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
  if serverId and 0 < serverId then
    local distance = math.ceil(SceneUtils.TileDistance(targetPos, myCityPos, serverId, LuaEntry.Player:GetSelfServerId()))
    SceneUtils.ReturnPoolV2(myCityPos)
    SceneUtils.ReturnPoolV2(targetPos)
    return distance
  else
    local distance = math.ceil(SceneUtils.TileDistance(targetPos, myCityPos))
    SceneUtils.ReturnPoolV2(myCityPos)
    SceneUtils.ReturnPoolV2(targetPos)
    return distance
  end
end

local function TileDistance(v2a, v2b, server1, server2)
  if server1 and server2 and 0 < server1 and 0 < server2 and server1 ~= server2 then
    local world1 = SceneUtils.TileToWorld(v2a, ForceChangeScene.World, server1)
    local world2 = SceneUtils.TileToWorld(v2b, ForceChangeScene.World, server2)
    local num1 = world1.x - world2.x
    local num2 = world1.z - world2.z
    return Mathf.Sqrt(num1 * num1 + num2 * num2) / TileSize
  else
    local num1 = v2a.x - v2b.x
    local num2 = v2a.y - v2b.y
    return Mathf.Sqrt(num1 * num1 + num2 * num2)
  end
end

local function ManhattanDistance(v2a, v2b)
  return math.abs(v2a.x - v2b.x) + math.abs(v2a.y - v2b.y)
end

local function IndexToTilePos(index, forceType)
  local tileCount = WorldTileCount
  if forceType ~= nil then
    if forceType == ForceChangeScene.World then
      tileCount = WorldTileCount
    else
      tileCount = CityTileCount
    end
  elseif isInCityScene == true then
    tileCount = CityTileCount
  end
  local square = tileCount * tileCount
  if index < 1 then
    Logger.LogInfo(string.format("ERR -> forceType : %s, idx : %s, tile : %s", forceType or "nil", index, tileCount))
    local ret = _NewV2()
    ret.x = 0
    ret.y = 0
    return ret
  elseif index > square then
    if forceType == nil and tileCount == CityTileCount then
      tileCount = WorldTileCount
    else
      Logger.LogInfo(string.format("ERR -> forceType : %s, idx : %s, tile : %s", forceType or "nil", index, tileCount))
      local ret = _NewV2()
      ret.x = 0
      ret.y = 0
      return ret
    end
  end
  index = index - 1
  local v2 = _NewV2()
  v2.x = index % tileCount
  v2.y = math.floor(index / tileCount)
  return v2
end

local function BigIndexToStandardIndex(index)
  return index // 10
end

local function BigIndexToTilePos(index, forceType)
  return SceneUtils.IndexToTilePos(SceneUtils.BigIndexToStandardIndex(index), forceType)
end

local function TilePosToIndex(tilePos, forceType)
  return SceneUtils.TileXYToIndex(tilePos.x, tilePos.y, forceType)
end

local function TileXYToIndex(x, y, forceType)
  local tileCount = WorldTileCount
  if forceType ~= nil then
    if forceType == ForceChangeScene.World then
      tileCount = WorldTileCount
    else
      tileCount = CityTileCount
    end
  elseif isInCityScene == true then
    tileCount = CityTileCount
  end
  if x < 0 or y < 0 or x > tileCount - 1 or y > tileCount - 1 then
    return 0
  end
  return x + y * tileCount + 1
end

local function TileIndexToWorld(index, forceType, theServerId)
  local tempPos = SceneUtils.IndexToTilePos(index, forceType)
  local ret = SceneUtils.TileToWorld(tempPos, forceType, theServerId)
  SceneUtils.ReturnPoolV2(tempPos)
  return ret
end

local function WorldToTileIndex(pos, forceType)
  local tempPos = SceneUtils.WorldToTile(pos)
  local ret = SceneUtils.TilePosToIndex(tempPos, forceType)
  SceneUtils.ReturnPoolV2(tempPos)
  return ret
end

local function GetIndexByOffsetX(index, offset, forceType)
  local temp = index - 1
  local tileCount = WorldTileCount
  if forceType ~= nil then
    if forceType ~= ForceChangeScene.World then
      tileCount = CityTileCount
    end
  elseif isInCityScene == true then
    tileCount = CityTileCount
  end
  temp = temp % tileCount
  temp = temp + offset
  if 0 <= temp and tileCount > temp then
    return index + offset
  end
  return 0
end

local function GetIndexByOffsetY(index, offset, forceType)
  local temp = index - 1
  local tileCount = WorldTileCount
  if forceType ~= nil then
    if forceType ~= ForceChangeScene.World then
      tileCount = CityTileCount
    end
  elseif isInCityScene == true then
    tileCount = CityTileCount
  end
  local _floor = math.floor
  temp = _floor(temp / tileCount)
  temp = temp + offset
  if 0 <= temp and tileCount > temp then
    return index + offset * tileCount
  end
  return 0
end

local function GetIndexByOffset(index, x, y, forceType)
  local temp = GetIndexByOffsetX(index, x, forceType)
  if 0 < temp then
    temp = GetIndexByOffsetY(temp, y, forceType)
    return temp
  end
  return 0
end

local function GetMarchCurPos(march)
  local position
  local status = march:GetMarchStatus()
  local path = string.split(march.path, ";")
  local curServerId = march.pathStartServerId
  if status == MarchStatus.MOVING or status == MarchStatus.BACK_HOME or status == MarchStatus.CHASING or status == MarchStatus.IN_WORM_HOLE then
    if 1 < #path then
      local serverNow = UITimeManager:GetInstance():GetServerTime()
      local pathLen = 0
      local BlackLandSpeed = DataCenter.BirthPointTemplateManager:GetBlackLandSpeedByServerId(curServerId)
      local blackEndTime = march.blackEndTime
      local blackStartTime = march.blackStartTime
      if blackEndTime ~= nil and blackStartTime ~= nil and 0 < blackStartTime and 0 < blackEndTime then
        local BlackLandMaxSpeed = DataCenter.BirthPointTemplateManager:GetBlackLandMaxSpeed()
        local BlackLandRealSpeed = math.min(BlackLandMaxSpeed, march.speed * BlackLandSpeed)
        if serverNow <= blackStartTime then
          pathLen = march.speed * (serverNow - march.startTime) * 0.001 * TileSize
        elseif serverNow <= blackEndTime then
          pathLen = march.speed * (blackStartTime - march.startTime) * 0.001 * TileSize
          pathLen = pathLen + (serverNow - blackStartTime) * 0.001 * TileSize * BlackLandRealSpeed
        else
          pathLen = march.speed * (blackStartTime - march.startTime) * 0.001 * TileSize
          pathLen = pathLen + (blackEndTime - blackStartTime) * 0.001 * TileSize * BlackLandRealSpeed
          pathLen = pathLen + march.speed * (serverNow - blackEndTime) * 0.001 * TileSize
        end
      else
        pathLen = march.speed * (serverNow - march.startTime) * 0.001 * TileSize
      end
      local pathSegment = SceneUtils.CreatePathSegment(march)
      position = SceneUtils.CalcMoveOnPath(pathSegment, 1, pathLen)
    else
      position = SceneUtils.TileIndexToWorld(march.targetPos, ForceChangeScene.World, march.targetServer)
    end
  elseif status == MarchStatus.TRANSPORT_BACK_HOME then
    position = SceneUtils.TileIndexToWorld(march.startPos, ForceChangeScene.World, march.srcServer)
  else
    position = SceneUtils.TileIndexToWorld(march.targetPos, ForceChangeScene.World, march.targetServer)
  end
  return position
end

local function CreatePathSegment(march)
  local path = string.split(march.path, ";")
  if #path < 2 then
    return nil
  end
  for i = 1, #path do
    path[i] = tonumber(path[i])
  end
  local pathList = {}
  for i = 1, #path do
    pathList[i] = {}
    if i < #path then
      local curPos = SceneUtils.TileIndexToWorld(path[i], ForceChangeScene.World, march.pathStartServerId)
      local nextPos = SceneUtils.TileIndexToWorld(path[i + 1], ForceChangeScene.World, march.targetServer)
      local pathVec = Vector3.New(nextPos.x - curPos.x, nextPos.y - curPos.y, nextPos.z - curPos.z)
      SceneUtils.ReturnPoolV3(nextPos)
      pathList[i].pos = curPos
      pathList[i].dir = Vector3.Normalize(pathVec)
      pathList[i].dist = Vector3.Magnitude(pathVec)
      pathVec:ReturnPool()
    else
      pathList[i].pos = SceneUtils.TileIndexToWorld(path[i], ForceChangeScene.World, march.targetServer)
      pathList[i].dir = pathList[i - 1].dir
      pathList[i].dist = LongMaxValue
    end
  end
  return pathList
end

local function CalcMoveOnPath(path, startIndex, startPathLen)
  local pathIdx = startIndex
  local pathLen = startPathLen
  local pos
  while pathIdx < #path and pathLen > path[pathIdx].dist do
    pathLen = path[pathIdx].dist - 1
    pathIdx = pathIdx + 1
  end
  if pathIdx < #path then
    pos = path[pathIdx].pos + path[pathIdx].dir * pathLen
  else
    pos = path[#path].pos
  end
  return pos
end

local function GetIsInCity()
  local curScene = CS.SceneManager.CurrSceneID
  return curScene == SceneManagerSceneID.City
end

local function GetIsInWorld()
  local curScene = CS.SceneManager.CurrSceneID
  return curScene == SceneManagerSceneID.World
end

local function GetIsInPve()
  local curScene = CS.SceneManager.CurrSceneID
  return curScene == SceneManagerSceneID.PVE
end

local function ChangeToCity(createAction)
  local action = createAction
  if SceneUtils.GetIsInCity() then
    if action ~= nil then
      action()
    end
  elseif SceneUtils.GetIsInWorld() then
    local start_time = socket.gettime()
    PostEventLog.Track(PostEventLog.Defines.change_to_city_start, {})
    EventManager:GetInstance():Broadcast(EventId.BeforeLeaveWorld)
    local scene = CS.SceneManager.World
    GoToUtil.CloseAllWindows()
    if BattleFieldUtil.InBattleField() then
      CrossServerUtil.OnBackSelfServerFromDragonWorld()
    end
    SFSNetwork.SendMessage(MsgDefines.LeaveWorld)
    LuaEntry.Player:SetCrossServerId(-1)
    CrossServerUtil.SetLastJumpToParam(nil)
    WorldMarchTileUIManager:GetInstance():OnExitWorld()
    WorldBuildUtil.CleanWorldAsyncObj()
    AllianceBuildBloodManager:GetInstance():RemoveAllEffect()
    TileBubbleManager:GetInstance():ExitWorld()
    DataCenter.BuildBubbleManager:ClearAll()
    DataCenter.WorldBuildBubbleManager:ClearAll()
    DataCenter.RoadBubbleManager:ClearAll()
    DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
    DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
    DataCenter.WarningBallManager:DeleteTimer()
    DataCenter.WorldFavoDataManager:ClearAll()
    DataCenter.ArrowManager:CloseAllArrow()
    DataCenter.LWWorldZoneChangeTipManager:RemoveTimer()
    DataCenter.LandlordMgr:OnExitWorld()
    DataCenter.SeasonDataManager:SetViewServerSkinMeta(nil)
    DataCenter.WorldTroopLineManager:Destroy()
    DataCenter.WorldBattleManager:OnExitWorld()
    DataCenter.WorldFakeBattleManager:OnExitWorld()
    DataCenter.LWTrainManager:ExitWorld()
    DataCenter.FlowerTrainGroupManager:ExitWorld()
    DataCenter.AllyDrillBaseManager:ExitWorld()
    DataCenter.ZombieBusTrainEntityManager:ExitWorld()
    DataCenter.AllianceWarDataManager:OnExitWorld()
    DataCenter.MonsterProtectionManager:ExitWorld()
    DataCenter.ActMeteoriteBattleManager:ExitWorld()
    DataCenter.SeasonDataManager:SetViewServerSkinMeta(nil)
    CS.SceneManager.DestroyScene(scene)
    SceneUtils.CreateCity()
    SceneUtils.SetIsInCity(true)
    collectgarbage("collect")
    CS.SceneManager.World:CreateScene(function()
      DataCenter.WarningBallManager:AddTimer()
      DataCenter.NpcQABubbleManager:SetQuestionBubbleFlag(true)
      DataCenter.SeasonDataManager:EnterCity()
      EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
      DataCenter.CityNpcManager:SetNpcVisible(true)
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      DataCenter.GuideManager:DoWaitTriggerAfterBack()
      if action ~= nil then
        action()
      end
      EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
      local end_time = socket.gettime()
      local elapsed_time = end_time - start_time
      Logger.Log("Change to city finish,use time:" .. elapsed_time)
      PostEventLog.Track(PostEventLog.Defines.change_to_city_finish, {end_time = elapsed_time})
    end)
  end
end

local function ChangeToWorld(createAction, noSendReq, noSendGoToWorld)
  local action = createAction
  if SceneUtils.GetIsInWorld() then
    if action ~= nil then
      action()
    end
  elseif SceneUtils.GetIsInCity() then
    local start_time = socket.gettime()
    PostEventLog.Track(PostEventLog.Defines.change_to_world_start, {})
    if not noSendGoToWorld then
      SFSNetwork.SendMessage(MsgDefines.GoToWorld)
    end
    local scene = CS.SceneManager.World
    EventManager:GetInstance():Broadcast(EventId.BeforeReleaseCity)
    GoToUtil.CloseAllWindows()
    EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
    AllianceBuildBloodManager:GetInstance():RemoveAllEffect()
    DataCenter.LandLockManager:DestroyAll()
    DataCenter.BuildBubbleManager:ClearAll()
    DataCenter.WorldBuildBubbleManager:ClearAll()
    DataCenter.RoadBubbleManager:ClearAll()
    DataCenter.ArrowManager:CloseAllArrow()
    DataCenter.SeasonPowerWorkerManager:DestroyWorkerMan()
    DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
    DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
    DataCenter.WarningBallManager:DeleteTimer()
    DataCenter.WorldFavoDataManager:ClearAll()
    DataCenter.NpcQABubbleManager:SetQuestionBubbleFlag(false)
    DataCenter.CityNpcManager:SetNpcVisible(false)
    DataCenter.ArmyFormationDataManager:FetchFormationSoldier()
    scene:UninitSubModulesAndCameraUpdate_withoutCameraMove()
    DataCenter.LWTrainManager:EnterWorld()
    DataCenter.FlowerTrainGroupManager:EnterWorld()
    DataCenter.AllyDrillBaseManager:EnterWorld()
    DataCenter.ZombieBusTrainEntityManager:EnterWorld()
    DataCenter.MonsterProtectionManager:EnterWorld()
    DataCenter.BirthPointTemplateManager:EnterWorld()
    DataCenter.SeasonDataManager:EnterWorld()
    SceneUtils.ClearALMemberPoints()
    EventManager:GetInstance():Broadcast(EventId.OnEnterWorldFromCity)
    scene:UninitCameraMovement()
    CS.SceneManager.DestroyScene(scene)
    SceneUtils.CreateWorld()
    SceneUtils.SetIsInCity(false)
    collectgarbage("collect")
    CS.SceneManager.World:CreateScene(function()
      DataCenter.WarningBallManager:AddTimer()
      DataCenter.LWWorldZoneChangeTipManager:AddTimer()
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      if action ~= nil then
        action()
      end
      EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
      local end_time = socket.gettime()
      local elapsed_time = end_time - start_time
      Logger.Log("Change to world finish,use time:" .. elapsed_time)
      PostEventLog.Track(PostEventLog.Defines.change_to_world_finish, {end_time = elapsed_time})
    end)
    if SeasonUtil.GetSeasonType() == SeasonMapType.Snow then
      CS.UnityEngine.Shader.DisableKeyword("HEATMAP_ON")
    end
  end
end

local function CheckCanGotoWorld(error_tip, enable_guide)
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_WorldBtn)
  if not unlock then
    if error_tip ~= nil and (type(error_tip) == "string" or type(error_tip) == "number") then
      UIUtil.ShowTipsId(error_tip)
    else
      UIUtil.ShowTipsId("E100101")
    end
    return false
  end
  return true
end

local function TryJoinAlliance(callback)
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if not string.IsNullOrEmpty(allianceId) then
    if callback ~= nil and type(callback) == "function" then
      callback(true)
    end
    return
  end
  local param = {
    agree_close = true,
    agree_callback = function()
      local params = {
        guide = false,
        al_success_callback = function()
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
          if callback ~= nil and type(callback) == "function" then
            callback(true)
          end
        end,
        al_lose_callback = function()
          if callback ~= nil and type(callback) == "function" then
            callback(false)
          end
        end
      }
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true}, params)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
      end
    end,
    dialog_id = 1001
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlGuide, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, param)
end

function SceneUtils:TryFastJoinAlliance(callback)
  local params = {
    guide = false,
    al_success_callback = function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
      if callback ~= nil and type(callback) == "function" then
        callback(true)
      end
    end,
    al_lose_callback = function()
      if callback ~= nil and type(callback) == "function" then
        callback(false)
      end
    end
  }
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true}, params)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function SceneUtils.IsInBlackOrYellowLand(pointId, serverId)
  return SceneUtils.IsInBlackLand(pointId, serverId) or SceneUtils.IsInYellowLand(pointId, serverId)
end

function SceneUtils.IsInBlackLand(pointId, serverId)
  return SceneUtils.IsInBlackRange(pointId, serverId) or DataCenter.AllianceSkillManager:GetBlackAreaOverTime(pointId, serverId) > 0
end

function SceneUtils.IsInYellowLand(pointId, serverId)
  return DataCenter.BirthPointTemplateManager:IsInAllianceCityField(pointId, serverId)
end

local function IsInBlackRange(pointId, serverId)
  if pointId == nil or pointId == 0 or pointId == -1 or BattleFieldUtil.InBattleField() and not BattleFieldUtil.isObserve then
    return false
  end
  local v2 = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local a, b, c, d = DataCenter.BirthPointTemplateManager:GetBlackLandRange(serverId)
  if v2.x >= a.x and v2.x <= b.x and v2.y <= a.y and v2.y >= d.y then
    SceneUtils.ReturnPoolV2(v2)
    return true
  end
  SceneUtils.ReturnPoolV2(v2)
  return false
end

local function IsInCityField(pointId, _serverId)
  if SeasonUtil.GetSeason() == 0 then
    return false
  end
  return DataCenter.BirthPointTemplateManager:IsInAllianceCityField(pointId, _serverId)
end

local function CreateWorld()
  if nil == SceneUtils.svc_world then
    SceneUtils.svc_world = Resource:LoadAsset(SVC_WORLD_PATH, typeof(CS.UnityEngine.ShaderVariantCollection)).asset
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ShaderWarmUp) then
    SceneUtils.svc_world:WarmUp()
  end
  CS.SceneManager.CreateWorld()
end

local function CreateCity()
  if nil == SceneUtils.svc_city then
    SceneUtils.svc_city = Resource:LoadAsset(SVC_CITY_PATH, typeof(CS.UnityEngine.ShaderVariantCollection)).asset
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ShaderWarmUp) then
    SceneUtils.svc_city:WarmUp()
  end
  CS.SceneManager.CreateCity()
end

local function IsIndexInWorld(index)
  if index <= 0 then
    return false
  end
  local tileCount = WorldTileCount
  index = index - 1
  local x = index % tileCount
  local y = math.floor(index / tileCount)
  return 0 <= x and x <= 999 and 0 <= y and y <= 999
end

function SceneUtils.SceneDescription(name, argsArray)
  local world = CS.SceneManager.World
  if world then
    local desc = world:Description(name, argsArray)
    if desc then
      Logger.LogWarning(desc)
    else
      Logger.LogWarning("Scene Description failed. ???")
    end
  else
    Logger.LogWarning("Scene Description failed. World is null.")
  end
end

function SceneUtils.GetZoneIdByPosId(pointId, serverId)
  if SceneUtils.GetIsInWorld() and CS.SceneManager.World ~= nil and serverId == LuaEntry.Player:GetCurServerId() then
    local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
    local zoneId = CS.SceneManager.World:GetZoneIdByWorldPos(worldPos)
    if zoneId ~= 0 then
      return zoneId
    end
  end
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local data = SeasonUtil.GetSeasonInfo(theServerId)
  if data and (data:ServerInReady() and data:InNormalMode() or data:InHaltMode()) then
    local theServerType = data:GetServerSubdivisionType(false)
    local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, theServerId)
    return CS.WorldZoneMapData.GetZoneIdByWorldPos(worldPos, theServerType)
  end
  return CS.WorldZoneMapData.GetZoneIdByPosId(pointId, 0)
end

function SceneUtils.GetOccupyServerIdByPosId(pointId, _serverId)
  local serverId = _serverId or LuaEntry.Player:GetCurServerId()
  local cityId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
  if cityInfo ~= nil then
    return cityInfo.occupyServerId or 0
  end
  return 0
end

function SceneUtils.GetCampIdByPosId(pointId, serverId)
  local occupyServerId = SceneUtils.GetOccupyServerIdByPosId(pointId, serverId)
  if occupyServerId ~= 0 then
    local mgr = CS.SeasonDataManager.Instance
    if mgr.GetCampIdByServerId then
      return mgr:GetCampIdByServerId(occupyServerId)
    end
  end
  return 0
end

function SceneUtils.GetBlackLengthByStartEnd(startTilePos, endTilePos, fromServer, toServer)
  if SceneUtils.IsBlackLandActive() then
    if DataCenter.LandlordMgr:IsInBattle() and DataCenter.LandlordMgr:IsInNewCenterMapPeriod() and fromServer == DataCenter.LandlordMgr:GetCenterServerId() then
      local dx = endTilePos.x - startTilePos.x
      local dy = endTilePos.y - startTilePos.y
      return math.sqrt(dx * dx + dy * dy)
    end
    return DataCenter.BirthPointTemplateManager:GetBlackLandIntersectionWithSegment(startTilePos, endTilePos, fromServer, toServer)
  end
  return 0
end

function SceneUtils.AxisAlignRectIntersectSegment(rectMinX, rectMinY, rectMaxX, rectMaxY, startX, startY, endX, endY)
  local num1 = math.min(startX, endX)
  local num2 = math.max(startX, endX)
  if rectMaxX < num2 then
    num2 = rectMaxX
  end
  if rectMinX > num1 then
    num1 = rectMinX
  end
  if num2 < num1 then
    return false
  end
  local num3 = math.min(startY, endY)
  local num4 = math.max(startY, endY)
  local f = endX - startX
  if math.abs(f) > 1.0E-6 then
    local num5 = (endY - startY) / f
    local num6 = startY - num5 * startX
    num3 = num5 * num1 + num6
    num4 = num5 * num2 + num6
  end
  if num3 > num4 then
    num3, num4 = num4, num3
  end
  if rectMaxY < num4 then
    num4 = rectMaxY
  end
  if rectMinY > num3 then
    num3 = rectMinY
  end
  return num4 >= num3
end

function SceneUtils.AxisAlignRectIntersectAxisAlignSegment(rectMinX, rectMinY, rectMaxX, rectMaxY, startX, startY, endX, endY)
  if startX == endX then
    if startX < rectMinX or rectMaxX < startX then
      return false
    end
    local segMinY = math.min(startY, endY)
    local segMaxY = math.max(startY, endY)
    return rectMinY <= segMaxY and rectMaxY >= segMinY
  elseif startY == endY then
    if startY < rectMinY or rectMaxY < startY then
      return false
    end
    local segMinX = math.min(startX, endX)
    local segMaxX = math.max(startX, endX)
    return rectMinX <= segMaxX and rectMaxX >= segMinX
  else
    return SceneUtils.AxisAlignRectIntersectSegment(rectMinX, rectMinY, rectMaxX, rectMaxY, startX, startY, endX, endY)
  end
end

function SceneUtils.IsBlackLandActive()
  if SeasonUtil.IsInSeasonNineNationMode(true) then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(loginServerId)
    if mapIndex == 5 then
      return DataCenter.SeasonNineKingManager:IsFighting(loginServerId)
    end
    if DataCenter.SeasonRainforestKingBattleManager:IsFighting() then
      return true
    end
  end
  if DataCenter.GovernmentManager:IsInBattlePhase() then
    return true
  end
  if DataCenter.ZoneWarManager:IsInBattlePhase() then
    return true
  end
  if DataCenter.LandlordMgr:IsInBattle() then
    return true
  end
  return false
end

local function PlayWorldEffect(pointId, serverId, prefabPath, lifeTime)
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil and SceneUtils.GetIsInWorld() then
    local curServerId = serverId or LuaEntry.Player:GetCurServerId()
    local tempPos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    local worldPos = SceneUtils.TileToWorld(tempPos, ForceChangeScene.World, curServerId)
    SceneUtils.ReturnPoolV2(tempPos)
    theWorld:CreateBattleVFX(prefabPath, lifeTime, function(go)
      if IsNotNull(go) and SceneUtils.GetIsInWorld() then
        go.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
        SceneUtils.ReturnPoolV3(worldPos)
      end
    end)
  end
end

function SceneUtils.PlayWorldEffect(pointId, serverId, prefabPath, lifeTime, delay)
  if delay then
    local _pointId = pointId
    local _prefabPath = prefabPath
    local _lifeTime = lifeTime
    local _serverId = serverId
    TimerManager:GetInstance():DelayInvoke(function()
      PlayWorldEffect(_pointId, _serverId, _prefabPath, _lifeTime)
    end, tonumber(delay) or 0.1)
  else
    PlayWorldEffect(pointId, serverId, prefabPath, lifeTime)
  end
end

function SceneUtils.PlayWorldSceneBGMusic()
  DataCenter.LWSoundManager:PlayWorldSceneBGMusic()
end

function SceneUtils.PlayGuideSceneBgMusic()
  DataCenter.LWSoundManager:PlayGuideSceneBgMusic()
end

function SceneUtils.PlayCityBGM()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness then
    SceneUtils.TryPlayDarkneesSeasonBloodyNightBGM()
    return
  end
  local soundId = DataCenter.SeasonDataManager:GetCityBGMId()
  if not string.IsNullOrEmpty(soundId) then
    DataCenter.LWSoundManager:PlaySound(soundId, false, true)
  end
end

function SceneUtils.PlayWorldBGM()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness then
    SceneUtils.TryPlayDarkneesSeasonBloodyNightBGM()
    return
  end
  if SceneUtils.TryPlayQueenOfBloodWorldBgm() then
    return
  end
  local soundId = DataCenter.SeasonDataManager:GetWorldBGMId()
  if not string.IsNullOrEmpty(soundId) then
    DataCenter.LWSoundManager:PlaySound(soundId, false, true)
  end
end

function SceneUtils.PlayWorldAMBSound()
  local soundId = DataCenter.SeasonDataManager:GetWorldAMBSoundId()
  if soundId ~= 0 then
    return DataCenter.LWSoundManager:PlayAMBSound(soundId), soundId
  end
end

function SceneUtils.PlayCityAMBSound()
  local soundId = DataCenter.SeasonDataManager:GetCityAMBSoundId()
  if soundId ~= 0 then
    return DataCenter.LWSoundManager:PlayAMBSound(soundId), soundId
  end
end

function SceneUtils.TryPlayDarkneesSeasonBloodyNightBGM()
  local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId())
  if isBloodyNight then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.BGM_Amb_S4_Bloodnight_Loop, false, true)
    return
  else
    local state, BNTemplate, startTime, endTime = DataCenter.BloodyNightDataManager:GetBloodyNightState()
    if state == BloodyNightState.Silent then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local remainTime = endTime - curTime
      if 0 <= remainTime and remainTime <= 21000 then
        local musicStartTime = 21000 - remainTime
        DataCenter.LWSoundManager:PlayBloodyNightTransitionBGM(musicStartTime)
        return
      end
    end
    local curScene = CS.SceneManager.CurrSceneID
    if curScene == SceneManagerSceneID.World then
      local soundId = DataCenter.SeasonDataManager:GetWorldBGMId()
      if not string.IsNullOrEmpty(soundId) then
        DataCenter.LWSoundManager:PlaySound(soundId, false, true)
      end
    else
      local soundId = DataCenter.SeasonDataManager:GetCityBGMId()
      if not string.IsNullOrEmpty(soundId) then
        DataCenter.LWSoundManager:PlaySound(soundId, false, true)
      end
    end
  end
  return
end

function SceneUtils.WorldToClosestGridWorld(worldPos)
  if SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetCurServerId()) then
    local serverId = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(worldPos)
    local tilePos = SceneUtils.WorldToTile(worldPos)
    return SceneUtils.TileToWorld(tilePos, ForceChangeScene.World, serverId)
  else
    local tilePos = SceneUtils.WorldToTile(worldPos)
    return SceneUtils.TileToWorld(tilePos, ForceChangeScene.World)
  end
end

function SceneUtils.GetCityMetaByPointIndex(pointId, serverId)
  local zoneId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId, serverId)
  return cityMeta
end

function SceneUtils.GetCampIdByPointIndex(pointId, serverId)
  local zoneId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(zoneId, serverId)
  if cityInfo and cityInfo.occupyServerId > 0 then
    return DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(cityInfo.occupyServerId)
  end
  return DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
end

function SceneUtils.TryPlayQueenOfBloodWorldBgm()
  local bgmId = DataCenter.OffSeason1QueenOfBloodManager:GetNeedPlayBgmId()
  if bgmId then
    DataCenter.LWSoundManager:PlaySound(bgmId, true)
    return true
  end
  return false
end

function SceneUtils.CheckNewAllianceMemberSwitch()
  return LuaEntry.DataConfig:CheckSwitch("allies_location_minimap")
end

local lastRequestALPointsTime = 0

function SceneUtils.WorldSendGetALPointsRequest()
  if not SceneUtils.CheckNewAllianceMemberSwitch() then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if BattleFieldUtil.InBattleField() then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - lastRequestALPointsTime < 10000 then
    return
  end
  local scene = CS.SceneManager.World
  if not scene then
    return
  end
  lastRequestALPointsTime = now
  scene:SendGetALPointsRequest(LuaEntry.Player:GetCurServerId())
end

function SceneUtils.ClearALMemberPoints()
  if not SceneUtils.CheckNewAllianceMemberSwitch() then
    return
  end
  lastRequestALPointsTime = 0
  if SceneUtils.GetIsInWorld() then
    local scene = CS.SceneManager.World
    if not scene then
      return
    end
    scene:ClearALMemberPoints()
  end
end

function SceneUtils.DecodeWorldPos(posVal)
  if not posVal then
    return 0, 0
  end
  local serverId = posVal >> 32
  local positionIndex = posVal & 4294967295
  return serverId, positionIndex
end

function SceneUtils.EncodeWorldPos(serverId, pointIndex)
  if not serverId or not pointIndex then
    return 0
  end
  return serverId << 32 | pointIndex
end

local SceneLuaArrayFacade = CS.SceneLuaArrayFacade
local sceneLuaArray, sceneLuaArrayAccess
local cityBuildNameIdMap = {}

function SceneUtils.GetSceneLuaArray()
  if sceneLuaArray == nil and SceneLuaArrayFacade then
    sceneLuaArray = LuaCSharpArray.New(128)
    sceneLuaArrayAccess = sceneLuaArray:GetCSharpAccess()
    SceneLuaArrayFacade.InitLongArrayAccess(sceneLuaArrayAccess)
  end
  return sceneLuaArray
end

function SceneUtils.CheckNeedSyncCityBuildIdName(buildId, buildLevel)
  local id = buildId << 32 | buildLevel
  local name = cityBuildNameIdMap[id]
  if name ~= nil then
    return false
  end
  return true
end

function SceneUtils.SyncCityBuildIdName(cityBuildName, buildId, buildLevel)
  local id = buildId << 32 | buildLevel
  local name = cityBuildNameIdMap[id]
  if name ~= nil then
    return
  end
  cityBuildNameIdMap[id] = cityBuildName
  if SceneLuaArrayFacade then
    SceneLuaArrayFacade.SyncCityBuildNameId(cityBuildName, id)
  end
end

function SceneUtils.UnInitSceneLuaArray()
  if sceneLuaArray then
    sceneLuaArray:DestroyCSharpAccess()
    sceneLuaArray = nil
    sceneLuaArrayAccess = nil
    cityBuildNameIdMap = {}
    if CS.SceneLuaArrayFacade then
      CS.SceneLuaArrayFacade.UnInitLongArrayAccess()
    end
  end
end

SceneUtils.IsInBlackRange = IsInBlackRange
SceneUtils.IsInCityField = IsInCityField
SceneUtils.SetIsInCity = SetIsInCity
SceneUtils.TileToWorld = TileToWorld
SceneUtils.ManhattanDistance = ManhattanDistance
SceneUtils.TileDistance = TileDistance
SceneUtils.TileDistanceToMyHome = TileDistanceToMyHome
SceneUtils.WorldToTile = WorldToTile
SceneUtils.WorldToTileXZ = WorldToTileXZ
SceneUtils.IndexToTilePos = IndexToTilePos
SceneUtils.BigIndexToStandardIndex = BigIndexToStandardIndex
SceneUtils.BigIndexToTilePos = BigIndexToTilePos
SceneUtils.TilePosToIndex = TilePosToIndex
SceneUtils.TileXYToIndex = TileXYToIndex
SceneUtils.TileIndexToWorld = TileIndexToWorld
SceneUtils.WorldToTileIndex = WorldToTileIndex
SceneUtils.GetIndexByOffset = GetIndexByOffset
SceneUtils.GetIndexByOffsetX = GetIndexByOffsetX
SceneUtils.GetIndexByOffsetY = GetIndexByOffsetY
SceneUtils.GetMarchCurPos = GetMarchCurPos
SceneUtils.CreatePathSegment = CreatePathSegment
SceneUtils.CalcMoveOnPath = CalcMoveOnPath
SceneUtils.WorldToTileFloat = WorldToTileFloat
SceneUtils.WorldToTileFloatXY = WorldToTileFloatXY
SceneUtils.GetIsInCity = GetIsInCity
SceneUtils.GetIsInWorld = GetIsInWorld
SceneUtils.GetIsInPve = GetIsInPve
SceneUtils.ChangeToWorld = ChangeToWorld
SceneUtils.ChangeToCity = ChangeToCity
SceneUtils.CreateWorld = CreateWorld
SceneUtils.CreateCity = CreateCity
SceneUtils.IsIndexInWorld = IsIndexInWorld
SceneUtils.CheckCanGotoWorld = CheckCanGotoWorld
SceneUtils.TryJoinAlliance = TryJoinAlliance
SceneUtils.ReturnPoolV2 = ReturnPoolV2
SceneUtils.ReturnPoolV3 = ReturnPoolV3
return ConstClass("SceneUtils", SceneUtils)
