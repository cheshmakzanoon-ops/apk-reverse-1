local WorldTriggerUtil = {}

function WorldTriggerUtil.GetPointsBySizeAndIndex(sz, index)
  local res = {}
  local vecPos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  if sz then
    vecPos.x = vecPos.x + (sz - 1) / 2
    vecPos.y = vecPos.y + (sz - 1) / 2
  end
  if sz ~= nil and 1 < sz then
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

function WorldTriggerUtil.IsCanPutDownBySize(size, index, theServerId)
  local points = WorldTriggerUtil.GetPointsBySizeAndIndex(size, index)
  if theServerId == nil then
    theServerId = LuaEntry.Player:GetCurServerId()
  end
  for k, v in pairs(points) do
    local putState = WorldTriggerUtil.IsCanPutDownByPoint(v, theServerId)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

function WorldTriggerUtil.IsCanPutDownByPoint(index, theServerId)
  local theWorld = CS.SceneManager.World
  if theWorld:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if theServerId == nil then
    theServerId = LuaEntry.Player:GetCurServerId()
  end
  if theWorld:GetTriggerDataByPointId(index, theServerId) then
    return BuildPutState.Landmine
  end
  local isInSeason = SeasonUtil.IsInSeasonOrHalt(theServerId)
  return BuildingUtils.IsCanPutDownInWorldByPoint(index, ResourceType.None, false, theWorld, isInSeason, true, theServerId)
end

function WorldTriggerUtil.IsCanPutDownWarFlagByPoint(index, theServerId)
  local theWorld = CS.SceneManager.World
  if theWorld:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if theServerId == nil then
    theServerId = LuaEntry.Player:GetCurServerId()
  end
  if DataCenter.WarFlagDataManager:CheckHasFlag(index, theServerId) then
    return BuildPutState.WarFlag
  end
  local isInSeason = SeasonUtil.IsInSeasonOrHalt(theServerId)
  return BuildingUtils.IsCanPutDownInWorldByPoint(index, ResourceType.None, false, theWorld, isInSeason, true, theServerId, true)
end

return ConstClass("WorldTriggerUtil", WorldTriggerUtil)
