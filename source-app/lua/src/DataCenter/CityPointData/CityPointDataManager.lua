local CityPointDataManager = BaseClass("CityPointDataManager")
local CityPointData = require("DataCenter.CityPointData.CityPointData")
local Data = CS.GameEntry.Data

local function __init(self)
  self.pointDict = {}
  self.uuidDict = {}
end

local function __delete(self)
  self.pointDict = nil
  self.uuidDict = nil
end

local function Startup(self)
end

local function AddUuid(self, uuid)
  local point = self.pointDict[tonumber(uuid)]
  if point == nil then
    return
  end
  for i = 0, point.size.x - 1 do
    for j = 0, point.size.y - 1 do
      local pointId = CS.SceneManager.World:GetIndexByOffset(point.pointId, -i, -j)
      self.uuidDict[pointId] = tonumber(uuid)
    end
  end
end

local function RemoveUuid(self, uuid)
  local point = self.pointDict[tonumber(uuid)]
  if point == nil then
    return
  end
  for i = 0, point.size.x - 1 do
    for j = 0, point.size.y - 1 do
      local pointId = CS.SceneManager.World:GetIndexByOffset(point.pointId, -i, -j)
      if self.uuidDict[pointId] == uuid then
        self.uuidDict[pointId] = nil
      end
    end
  end
end

local function InitData(self, message)
  local dataList = message.cityPoints
  if table.IsNullOrEmpty(dataList) then
    return
  end
  self.pointDict = {}
  self.pointIdToUuid = {}
  for _, data in pairs(dataList) do
    self:SetPointDataByUuid(data.uuid, data)
  end
end

local function UpdateData(self, message)
  local dataList = message.cityPoints
  if table.IsNullOrEmpty(dataList) then
    return
  end
  for _, data in pairs(dataList) do
    self:SetPointDataByUuid(data.uuid, data)
  end
end

local function SetPointDataByUuid(self, uuid, data)
  local point = CityPointData.New()
  point:SetData(data)
  self.pointDict[tonumber(uuid)] = point
  self:AddUuid(data.uuid)
  if data.type == CityPointType.MonsterReward then
    EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateCityPoint, data.pointId)
end

local function GetAllPointData(self)
  return self.pointDict
end

local function GetPointDataByUuid(self, uuid)
  return self.pointDict[tonumber(uuid)]
end

local function GetPointDataByPointId(self, pointId)
  local uuid = self.uuidDict[tonumber(pointId)]
  return self:GetPointDataByUuid(uuid)
end

local function GetPointDataByItemId(self, itemId)
  for _, point in pairs(self.pointDict) do
    if point.itemId == tostring(itemId) then
      return point
    end
  end
  return nil
end

local function GetPointDataListByType(self, type)
  local list = {}
  for _, point in pairs(self.pointDict) do
    if point.type == tonumber(type) then
      table.insert(list, point)
    end
  end
  return list
end

local function RemovePointDataByUuid(self, uuid)
  local point = self.pointDict[tonumber(uuid)]
  if point == nil then
    return
  end
  local pointId = point.pointId
  self:RemoveUuid(uuid)
  self.pointDict[tonumber(uuid)] = nil
  EventManager:GetInstance():Broadcast(EventId.UpdateCityPoint, pointId)
end

local function RemovePointDataByPointId(self, pointId)
  local uuid = self.uuidDict[tonumber(pointId)]
  self:RemovePointDataByUuid(uuid)
end

local function SearchMonsterPointData(self, level, checkFog)
  local pointList = {}
  local fogPointList = {}
  for _, point in pairs(self.pointDict) do
    if point.type == CityPointType.Monster then
      local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(point.itemId)
      if template ~= nil and tonumber(template.level) == level then
        if Data.Fog:IsUnlock(point.pointId) then
          table.insert(pointList, point)
        elseif not checkFog then
          table.insert(fogPointList, point)
        end
      elseif template ~= nil and level == 0 then
        if Data.Fog:IsUnlock(point.pointId) then
          table.insert(pointList, point)
        elseif not checkFog then
          table.insert(fogPointList, point)
        end
      end
    end
  end
  local cityTroop = CS.SceneManager.World:GetCityTroop()
  local searchTilePos
  if cityTroop ~= nil then
    searchTilePos = CS.SceneManager.World:WorldToTile(cityTroop.transform.position)
  else
    searchTilePos = DataCenter.BuildManager.main_city_pos
  end
  return self:SearchMinDisPoint(searchTilePos, pointList) or self:SearchMinDisPoint(searchTilePos, fogPointList)
end

local function SearchGarbagePointData(self, pointId, isReward)
  local pointList = {}
  for _, point in pairs(self.pointDict) do
    if point.type == CityPointType.Garbage and Data.Fog:IsUnlock(point.pointId) then
      table.insert(pointList, point)
    end
    if isReward and point.type == CityPointType.GarbageReward and Data.Fog:IsUnlock(point.pointId) then
      table.insert(pointList, point)
    end
  end
  local searchTilePos
  local world = CS.SceneManager.World
  if world == nil then
    Logger.LogError("World is not loaded when SearchGarbagePointData")
    return nil
  end
  if pointId and 0 < pointId then
    searchTilePos = world:IndexToTilePos(pointId)
  else
    local cityTroop = world:GetCityTroop()
    if cityTroop ~= nil then
      searchTilePos = world:WorldToTile(cityTroop.transform.position)
    else
      searchTilePos = DataCenter.BuildManager.main_city_pos
    end
  end
  return self:SearchMinDisPoint(searchTilePos, pointList)
end

local function SearchGarbagePointDataByResourceType(self, resourceType, isReward)
  local pointList = {}
  for _, point in pairs(self.pointDict) do
    if point.type == CityPointType.Garbage and Data.Fog:IsUnlock(point.pointId) then
      local garbageResourceType = LocalController:instance():getStrValue(TableName.CityJunk, point.itemId, "Type")
      if tonumber(garbageResourceType) == resourceType then
        table.insert(pointList, point)
      end
    end
    if isReward and point.type == CityPointType.GarbageReward and Data.Fog:IsUnlock(point.pointId) then
      local garbageResourceType = LocalController:instance():getStrValue(TableName.CityJunk, point.itemId, "Type")
      if tonumber(garbageResourceType) == resourceType then
        table.insert(pointList, point)
      end
    end
  end
  local cityTroop = CS.SceneManager.World:GetCityTroop()
  local searchTilePos
  if cityTroop ~= nil then
    searchTilePos = CS.SceneManager.World:WorldToTile(cityTroop.transform.position)
  else
    searchTilePos = DataCenter.BuildManager.main_city_pos
  end
  return self:SearchMinDisPoint(searchTilePos, pointList)
end

local function SearchMinDisPoint(self, searchTilePos, pointList)
  local minDis = IntMaxValue
  local minDisPoint, rewardPoint
  local isHaveReward = false
  for _, point in pairs(pointList) do
    local tilePos = CS.SceneManager.World:IndexToTilePos(point.pointId)
    local dis = (tilePos.x - searchTilePos.x) ^ 2 + (tilePos.y - searchTilePos.y) ^ 2
    if point.type == CityPointType.GarbageReward then
      isHaveReward = true
      if minDis > dis then
        minDis = dis
        rewardPoint = point
      end
    elseif dis < minDis then
      minDis = dis
      minDisPoint = point
    end
  end
  return isHaveReward and rewardPoint or minDisPoint
end

local function RemoveAll(self)
end

CityPointDataManager.RemoveAll = RemoveAll
CityPointDataManager.__init = __init
CityPointDataManager.__delete = __delete
CityPointDataManager.SearchMinDisPoint = SearchMinDisPoint
CityPointDataManager.Startup = Startup
CityPointDataManager.AddUuid = AddUuid
CityPointDataManager.RemoveUuid = RemoveUuid
CityPointDataManager.InitData = InitData
CityPointDataManager.UpdateData = UpdateData
CityPointDataManager.SetPointDataByUuid = SetPointDataByUuid
CityPointDataManager.GetAllPointData = GetAllPointData
CityPointDataManager.GetPointDataByUuid = GetPointDataByUuid
CityPointDataManager.GetPointDataByPointId = GetPointDataByPointId
CityPointDataManager.GetPointDataByItemId = GetPointDataByItemId
CityPointDataManager.GetPointDataListByType = GetPointDataListByType
CityPointDataManager.RemovePointDataByUuid = RemovePointDataByUuid
CityPointDataManager.RemovePointDataByPointId = RemovePointDataByPointId
CityPointDataManager.SearchMonsterPointData = SearchMonsterPointData
CityPointDataManager.SearchGarbagePointData = SearchGarbagePointData
CityPointDataManager.SearchGarbagePointDataByResourceType = SearchGarbagePointDataByResourceType
return CityPointDataManager
