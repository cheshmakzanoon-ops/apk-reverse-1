local CityPointManager = BaseClass("CityPointManager")
local Data = CS.GameEntry.Data

local function __init(self)
end

local function __delete(self)
end

local function Startup(self)
end

local function GetPointType(self, pointId)
  local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
  if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
    return CityPointType.Building
  end
  local boardData = DataCenter.BoardManager:GetBoardDataByPointId(pointId)
  if boardData ~= nil then
    return CityPointType.Road
  end
  local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(pointId)
  if pointData ~= nil then
    return pointData.type
  end
  local collect = DataCenter.CollectResourceManager:GetResourcePointInfoByIndex(pointId)
  if collect ~= nil then
    return CityPointType.Collect
  end
  local collectRange = DataCenter.CollectResourceManager:GetCollectRangeInfoByIndex(pointId)
  if collectRange ~= nil then
    return CityPointType.CollectRange
  end
  return CityPointType.Other
end

local function GetPointSize(self, pointId)
  local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
  if buildData ~= nil then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.type)
    if buildTemplate ~= nil then
      return buildTemplate.tileX
    end
  end
  local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(pointId)
  if pointData ~= nil then
    return math.max(pointData.size.x, pointData.size.y)
  end
  return BuildTilesType.One
end

CityPointManager.__init = __init
CityPointManager.__delete = __delete
CityPointManager.Startup = Startup
CityPointManager.GetPointType = GetPointType
CityPointManager.GetPointSize = GetPointSize
return CityPointManager
