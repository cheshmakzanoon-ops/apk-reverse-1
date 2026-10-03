local InnerCityMapManager = BaseClass("InnerCityMapManager")
local CityDoorManager = require("Scene.Pathfinding.Map.CityDoorManager")
local lanlackWight = 12
local lanlackCont = 5
local wight = 2
local left = 28
local top = 28
local canWalkid = 5

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.OnBuildInMap)
  EventManager:GetInstance():AddListener(EventId.BuildingMove, self.OnBuildMove)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.OnBuildInMap)
  EventManager:GetInstance():RemoveListener(EventId.BuildingMove, self.OnBuildMove)
end

local function __init(self)
end

local function __delete(self)
end

local function PosToIndex(self, pos)
  if pos then
    local x = math.floor((pos.x - self.pos.x + left) / self.wight + 0.5)
    local y = math.floor((pos.z - self.pos.z + top) / self.wight + 0.5)
    return {x = x, y = y}
  end
end

local function IndexToPos(self, x, y)
  local V3X = self.pos.x - left + self.wight / 2 + self.wight * (x - 1)
  local V3Z = self.pos.z - top + self.wight / 2 + self.wight * (y - 1)
  return Vector3.New(V3X, self.pos.y, V3Z)
end

local function OnBuildInMap(uuid)
  DataCenter.InnerCityMapManager:UpdateMapBuildByUuid(uuid)
end

local function OnBuildMove(moveData)
  DataCenter.InnerCityMapManager:UpdateMapByMoveData(moveData)
end

local function TableToArray(tableList)
  local paramArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector2Int), #tableList)
  for k, v in pairs(tableList) do
    paramArray[k - 1] = CS.UnityEngine.Vector2Int(v.x, v.y)
  end
  return paramArray
end

local function ListToTable(CSharpList)
  local list = {}
  if CSharpList then
    local index = 1
    local iter = CSharpList:GetEnumerator()
    while iter:MoveNext() do
      local v = iter.Current
      list[index] = v
      index = index + 1
    end
  end
  return list
end

local function GetMapInfo(self)
  self.map = {}
  self.wight = wight
  self.x = lanlackWight / self.wight * lanlackCont
  self.y = lanlackWight / self.wight * lanlackCont
end

local function GetOneBuildObstacle(self, mapIndexList, buildingData)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildingData.itemId)
  if not line then
    Logger.LogError("building\232\161\168\233\135\140\230\178\161\230\156\137\232\191\153\228\184\170id\239\188\154" .. buildingData.itemId)
  end
  local v2 = string.split(line.tiles_2, ";")
  local pos = SceneUtils.TileIndexToWorld(buildingData.pointId)
  local v2_mapIndex = PosToIndex(self, pos)
  local v2_tempMapIndex = {}
  for i = tonumber(v2[1]) - 1, 0, -1 do
    for j = tonumber(v2[2]) - 1, 0, -1 do
      if v2_mapIndex.x - i <= self.x and v2_mapIndex.y - j <= self.y and 0 <= v2_mapIndex.x - i and 0 <= v2_mapIndex.y - j then
        v2_tempMapIndex = {
          x = v2_mapIndex.x - i,
          y = v2_mapIndex.y - j
        }
        table.insert(mapIndexList, v2_tempMapIndex)
      end
    end
  end
  return mapIndexList
end

local function SetOnLanLock(self, v2_mapIndex, mapIndexList, v2_tempMapIndex, i)
  for j = 2, 0, -1 do
    if v2_mapIndex.x - i <= self.x and v2_mapIndex.y - j <= self.y and 0 <= v2_mapIndex.x - i and 0 <= v2_mapIndex.y - j then
      v2_tempMapIndex = {
        x = v2_mapIndex.x - i,
        y = v2_mapIndex.y - j
      }
      table.insert(mapIndexList, v2_tempMapIndex)
      v2_tempMapIndex = {
        x = v2_mapIndex.x - i,
        y = v2_mapIndex.y - -j
      }
      table.insert(mapIndexList, v2_tempMapIndex)
      if j == 2 then
        v2_tempMapIndex = {
          x = v2_mapIndex.x - i,
          y = v2_mapIndex.y - j - 1
        }
        table.insert(mapIndexList, v2_tempMapIndex)
      end
    end
  end
end

local function GetOneLanLockObstacle(self, mapIndexList, lanlackData)
end

local function GenerateObstacle(self)
  local buildDataList = DataCenter.BuildManager:GetAllBuildData()
  local mapIndexList = {}
  for i, data in pairs(buildDataList) do
    GetOneBuildObstacle(self, mapIndexList, data)
  end
  local lanlackDataDic = DataCenter.LandLockManager:GetAlllandLockData()
  for id, data in pairs(lanlackDataDic) do
    if id >= canWalkid and (data == nil or data.state ~= LandLockState.Finished) then
      GetOneLanLockObstacle(self, mapIndexList, data)
    end
  end
  return mapIndexList
end

local function UnlockZone(self, id)
end

local function InitMap(self)
end

local function UpdateMapBuildByUuid(self, uuid)
  local buildPointList = {}
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData then
    buildPointList = GetOneBuildObstacle(self, buildPointList, buildData)
    local paramArray = TableToArray(buildPointList)
    self.JPS:UpdateMap(paramArray, 1)
  end
end

local function FindCityPath(self, starPos, endPos)
  local pathJPS = {
    Vector3.New(starPos.x, starPos.y, starPos.z),
    Vector3.New(endPos.x, endPos.y, endPos.z)
  }
  if Vector3.Distance(starPos, endPos) < wight * 16 then
    return pathJPS
  end
  local tempPathList
  if self.JPS then
    local v2_startMapIndex = PosToIndex(self, starPos)
    local v2_endMapIndex = PosToIndex(self, endPos)
    local startV2 = CS.UnityEngine.Vector2Int(v2_startMapIndex.x, v2_startMapIndex.y)
    local endV2 = CS.UnityEngine.Vector2Int(v2_endMapIndex.x, v2_endMapIndex.y)
    pathJPS = self.JPS:GetPath(startV2, endV2)
    tempPathList = ListToTable(pathJPS)
    pathJPS = {}
    for i = #tempPathList, 1, -1 do
      table.insert(pathJPS, IndexToPos(self, tempPathList[i].x, tempPathList[i].y))
    end
  end
  return pathJPS
end

local function UpdateMapByMoveData(self, moveData)
  local oldBuildPointList = {}
  local newBuildPointList = {}
  if moveData then
    oldBuildPointList = GetOneBuildObstacle(self, oldBuildPointList, moveData.old)
    newBuildPointList = GetOneBuildObstacle(self, newBuildPointList, moveData.new)
    local paramArray1 = TableToArray(oldBuildPointList)
    local paramArray2 = TableToArray(newBuildPointList)
    self.JPS:UpdateMap(paramArray1, 0)
    self.JPS:UpdateMap(paramArray2, 1)
  end
end

local function IsInCityMap(self, pos)
  local v2_mapIndex = PosToIndex(self, pos)
  if v2_mapIndex.x <= self.x and v2_mapIndex.x >= 0 and v2_mapIndex.y <= self.y and 0 <= v2_mapIndex.y then
    return true
  end
end

local function GetCityDoorManager(self)
  if not self.CityDoorManager then
    self.CityDoorManager = CityDoorManager.New()
  end
  return self.CityDoorManager
end

local function GoCity(self, starPos, endPos, isEndPosInCity)
  local pathJPS
  if not self.doorStartPos or not self.doorEndPos then
    self.doorStartPos, self.doorEndPos = self.GetCityDoorManager(self):GetDoorPos()
  end
  if self.doorStartPos and self.doorEndPos then
    pathJPS = FindCityPath(self, self.doorStartPos, endPos)
    if not pathJPS then
      return {}
    end
    if 0 < #pathJPS then
      table.remove(pathJPS, 1)
    end
    local index = 1
    if 0 < #pathJPS then
      index = isEndPosInCity and 1 or #pathJPS
    else
      return {starPos, endPos}
    end
    local startPos = isEndPosInCity and self.doorStartPos or self.doorEndPos
    local endPos = isEndPosInCity and self.doorEndPos or self.doorStartPos
    table.insert(pathJPS, index, startPos)
    table.insert(pathJPS, index, endPos)
  end
  return pathJPS
end

local function FindPath(self, starPos, endPos)
  return {starPos, endPos}
end

local function FindShortestDistancePos(self, pos)
  local v2_mapIndex = PosToIndex(self, pos)
  if v2_mapIndex.x > self.x then
    v2_mapIndex.x = self.x
  elseif v2_mapIndex.x < 1 then
    v2_mapIndex.x = 1
  end
  if v2_mapIndex.y > self.y then
    v2_mapIndex.y = self.y
  elseif 1 > v2_mapIndex.y then
    v2_mapIndex.y = 1
  end
  return IndexToPos(self, v2_mapIndex.x, v2_mapIndex.y)
end

InnerCityMapManager.AddListeners = AddListeners
InnerCityMapManager.__init = __init
InnerCityMapManager.UpdateMapByMoveData = UpdateMapByMoveData
InnerCityMapManager.UpdateMapBuildByUuid = UpdateMapBuildByUuid
InnerCityMapManager.OnBuildInMap = OnBuildInMap
InnerCityMapManager.OnBuildMove = OnBuildMove
InnerCityMapManager.__delete = __delete
InnerCityMapManager.InitMap = InitMap
InnerCityMapManager.FindPath = FindPath
InnerCityMapManager.FindShortestDistancePos = FindShortestDistancePos
InnerCityMapManager.UnlockZone = UnlockZone
InnerCityMapManager.GetCityDoorManager = GetCityDoorManager
return InnerCityMapManager
