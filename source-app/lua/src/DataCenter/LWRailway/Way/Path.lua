local Path = DataClass("Path")
local Depot = require("DataCenter.LWRailway.Way.Depot")

function Path:__init(startIndex, stationList, worldCityTableName, serverId)
  self.pathPoints = {}
  self.debugWayList = {}
  self.worldCityTableName = worldCityTableName
  self.pathPoints[0] = Depot.New(0, startIndex, TrainStationType.Main, worldCityTableName, serverId)
  table.insert(self.debugWayList, startIndex)
  self.numOfPoint = table.csCount(stationList) + 1
  if type(stationList) == "table" then
    for i = 1, self.numOfPoint - 1 do
      local pathPoint = Depot.New(i, stationList[i], TrainStationType.City, worldCityTableName, serverId)
      self.pathPoints[i] = pathPoint
      table.insert(self.debugWayList, pathPoint.id)
    end
  else
    for i = 0, self.numOfPoint - 2 do
      local pathPoint = Depot.New(i + 1, stationList[i], TrainStationType.City, worldCityTableName, serverId)
      self.pathPoints[i] = pathPoint
      table.insert(self.debugWayList, pathPoint.id)
    end
  end
end

function Path:__delete()
  self:Destroy()
end

function Path:Destroy()
  if self.pathPoints then
    for _, v in pairs(self.pathPoints) do
      v:Delete()
    end
  end
  self.pathPoints = nil
  self.debugWayList = nil
  self.debugWayListLog = nil
end

function Path:GetNextPointDistance(point)
  local nextPoint = self:GetNextPoint(point)
  if nextPoint then
    return Vector3.Distance(point:GetPos(), nextPoint:GetPos())
  else
    return 0
  end
end

function Path:GetNextPoint(point)
  return self.pathPoints[point.index + 1]
end

function Path:GetPrevPoint(point)
  return self.pathPoints[point.index - 1]
end

function Path:GetPoint(index)
  return self.pathPoints[index]
end

function Path:GetLength()
  local ret = 0
  for i = 0, self.numOfPoint - 2 do
    ret = ret + Vector3.Distance(self.pathPoints[i]:GetPos(), self.pathPoints[i + 1]:GetPos())
  end
  return ret
end

function Path:GetDebugWayList()
  if self.debugWayListLog == nil then
    if self.debugWayList ~= nil then
      self.debugWayListLog = table.concat(self.debugWayList, "-")
    else
      self.debugWayListLog = ""
    end
  end
  return self.debugWayListLog, self.worldCityTableName or ""
end

return Path
