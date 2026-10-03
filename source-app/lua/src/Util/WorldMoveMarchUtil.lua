local WorldMoveMarchUtil = {}

local function GetMarchMonsterSize(uuid)
  local sz = 0
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if marchInfo and marchInfo.monsterId then
    sz = tonumber(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), marchInfo.monsterId, "size"))
  end
  return sz
end

local function GetMarchPointsBySizeAndIndex(sz, index)
  local res = {}
  local vecPos = {x = 0, y = 0}
  if index ~= -1 and index ~= 0 then
    vecPos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  end
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

local function IsCanPutDownBySize(size, index)
  local points = WorldMoveMarchUtil.GetMarchPointsBySizeAndIndex(size, index)
  for k, v in pairs(points) do
    local putState = WorldMoveMarchUtil.IsCanPutDownByPoint(v)
    if putState ~= BuildPutState.Ok then
      return putState
    end
  end
  return BuildPutState.Ok
end

local function IsCanPutDownByPoint(index)
  local theWorld = CS.SceneManager.World
  if theWorld:IsInMapByIndex(index) == false then
    return BuildPutState.OutUnlockRange
  end
  if DataCenter.MonsterLockDataManager:GetMonsterDataByPointIndex(index) ~= nil then
    return BuildPutState.PveMonster
  end
  if SceneUtils.IsInBlackRange(index) then
    return BuildPutState.InBlackLandRange
  end
  if SeasonUtil.IsInSeasonOrHalt(LuaEntry.Player:GetCurServerId()) and DataCenter.BirthPointTemplateManager:IsInAllianceCityField(index) then
    return BuildPutState.HasCityStrongholdMonster
  end
  local marchState = BuildingUtils.CanPutDownWithMarch(index, true)
  if marchState ~= BuildPutState.Ok then
    return marchState
  end
  local isInSeason = SeasonUtil.IsInSeasonOrHalt(LuaEntry.Player:GetCurServerId())
  return BuildingUtils.IsCanPutDownInWorldByPoint(index, ResourceType.None, false, theWorld, isInSeason, true)
end

local function CreateMoveMarch(uuid)
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if marchInfo and marchInfo:IsDrillBase() then
    local modelPath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), marchInfo.monsterId, "model_name")
    CS.SceneManager.World:UICreateWorldMoveMarch(modelPath, uuid, marchInfo.position)
  end
end

WorldMoveMarchUtil.GetMarchPointsBySizeAndIndex = GetMarchPointsBySizeAndIndex
WorldMoveMarchUtil.GetMarchMonsterSize = GetMarchMonsterSize
WorldMoveMarchUtil.IsCanPutDownBySize = IsCanPutDownBySize
WorldMoveMarchUtil.IsCanPutDownByPoint = IsCanPutDownByPoint
WorldMoveMarchUtil.CreateMoveMarch = CreateMoveMarch
return ConstClass("WorldMoveMarchUtil", WorldMoveMarchUtil)
