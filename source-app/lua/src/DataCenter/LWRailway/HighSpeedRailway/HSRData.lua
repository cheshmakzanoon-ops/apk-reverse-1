local HSRData = BaseClass("HSRData")
local HSRStation = require("DataCenter.LWRailway.HighSpeedRailway.HSRStation")
local CARRIAGE_LENGTH = 2.85
local north = {
  {x = 2999, z = 2999},
  {x = 2999, z = 4999},
  {x = 999, z = 4999},
  {x = 999, z = 2999},
  {x = 999, z = 999},
  {x = 2999, z = 999},
  {x = 4999, z = 999},
  {x = 4999, z = 2999},
  {x = 4999, z = 4999},
  {x = 2999, z = 4999},
  {x = 2999, z = 2999}
}
local south = {
  {x = 2999, z = 2999},
  {x = 2999, z = 999},
  {x = 4999, z = 999},
  {x = 4999, z = 2999},
  {x = 4999, z = 4999},
  {x = 2999, z = 4999},
  {x = 999, z = 4999},
  {x = 999, z = 2999},
  {x = 999, z = 999},
  {x = 2999, z = 999},
  {x = 2999, z = 2999}
}
local west = {
  {x = 2999, z = 2999},
  {x = 999, z = 2999},
  {x = 999, z = 999},
  {x = 2999, z = 999},
  {x = 4999, z = 999},
  {x = 4999, z = 2999},
  {x = 4999, z = 4999},
  {x = 2999, z = 4999},
  {x = 999, z = 4999},
  {x = 999, z = 2999},
  {x = 2999, z = 2999}
}
local east = {
  {x = 2999, z = 2999},
  {x = 4999, z = 2999},
  {x = 4999, z = 4999},
  {x = 2999, z = 4999},
  {x = 999, z = 4999},
  {x = 999, z = 2999},
  {x = 999, z = 999},
  {x = 2999, z = 999},
  {x = 4999, z = 999},
  {x = 4999, z = 2999},
  {x = 2999, z = 2999}
}
local rapidjson = require("rapidjson")

function HSRData:__init()
end

function HSRData:__delete()
  self:Destroy()
end

function HSRData:Destroy()
  self:RemoveStations()
end

function HSRData:RemoveStations()
  if self.stations then
    for k, v in pairs(self.stations) do
      v:Delete()
    end
  end
  self.stations = {}
end

function HSRData:InitByNet(msg)
  self:RemoveStations()
  self.uuid = msg.uuid
  self.durationBetweenStations = WorldTileCount / DataCenter.HSRDataManager:GetHSRSpeed() * 1000
  self.frequencyBetweenStations = 1 / self.durationBetweenStations
  self.createTime = msg.createTrainTime
  self.startTime = msg.sendTime
  if not self.startTime or self.startTime <= 0 then
    self.startTime = self.createTime + DataCenter.HSRDataManager:GetHSRWaitTime()
  end
  if self.debugTime then
    self.startTime = self.debugTime
  end
  self:SetCarriageCount(msg.passengerCount)
  local prevPos = Vector3.zero
  local prevServerId = 0
  local prevStationId = 0
  local i = 0
  for _, buyMaxNum in ipairs(msg.buyMaxNumList) do
    local thisStationId = buyMaxNum.station
    local thisServerId = buyMaxNum.serverId
    local _, pointIndex = SeasonUtil.GetKingCityId(thisServerId)
    local thisPos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World, thisServerId)
    if self.debugDirection then
      if self.debugDirection == HSRDirection.North then
        thisPos = {
          x = north[i + 1].x,
          y = 0,
          z = north[i + 1].z
        }
      elseif self.debugDirection == HSRDirection.South then
        thisPos = {
          x = south[i + 1].x,
          y = 0,
          z = south[i + 1].z
        }
      elseif self.debugDirection == HSRDirection.West then
        thisPos = {
          x = west[i + 1].x,
          y = 0,
          z = west[i + 1].z
        }
      elseif self.debugDirection == HSRDirection.East then
        thisPos = {
          x = east[i + 1].x,
          y = 0,
          z = east[i + 1].z
        }
      end
    end
    if 0 < i then
      local rotation = self:Vector3ToDirection(thisPos.x - prevPos.x, thisPos.z - prevPos.z)
      if rotation == HSRDirection.None then
        local jsonMsg = rapidjson.encode(msg)
        Logger.LogError("\231\129\171\232\189\166\228\187\142" .. prevServerId .. "\230\156\141\229\136\176" .. thisServerId .. "\230\156\141\239\188\159\231\129\171\232\189\166\228\184\141\232\131\189\230\150\156\231\157\128\229\188\128\239\188\129prevPos=" .. prevPos.x .. "," .. prevPos.z .. ",thisPos=" .. thisPos.x .. "," .. thisPos.z .. ",msg=" .. jsonMsg)
      end
      table.insert(self.stations, HSRStation.New(prevServerId, prevPos, rotation, prevStationId))
    end
    prevPos = thisPos
    prevServerId = thisServerId
    prevStationId = thisStationId
    i = i + 1
  end
  table.insert(self.stations, self.stations[1])
  local duration = self.durationBetweenStations * (#self.stations - 1)
  self.endTime = self.startTime + duration
end

function HSRData:Vector3ToDirection(x, z)
  if math.abs(z) < 1 then
    if 0 < x then
      return HSRDirection.East
    end
    return HSRDirection.West
  end
  if math.abs(x) < 1 then
    if 0 < z then
      return HSRDirection.North
    end
    return HSRDirection.South
  end
  return HSRDirection.None
end

function HSRData:SetCarriageCount(passengerCount)
  local maxPassengerPerCarriage = DataCenter.HSRDataManager:GetMaxPassengerPerCarriage()
  local carriageCount = math.ceil(passengerCount / maxPassengerPerCarriage)
  carriageCount = math.max(carriageCount, 7)
  carriageCount = math.min(carriageCount, 50)
  self.carriageCount = carriageCount
  self.tailDelay = self:GetDelay(carriageCount + 1)
end

function HSRData:GetCarriageCount()
  return self.carriageCount
end

function HSRData:GetDelay(carriageIndex)
  return carriageIndex * CARRIAGE_LENGTH * 1000 / DataCenter.HSRDataManager:GetHSRSpeed()
end

function HSRData:IsInView(viewMinX, viewMinY, viewMaxX, viewMaxY)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.startTime then
    return false
  end
  local headPos, headDir, headStationIndex = self:GetPosition(now)
  local tailPos, tailDir = self:GetPosition(now - self.tailDelay)
  headPos = SceneUtils.WorldToUniqueTile(headPos)
  tailPos = SceneUtils.WorldToUniqueTile(tailPos)
  local isInView
  if headDir == tailDir then
    isInView = SceneUtils.AxisAlignRectIntersectAxisAlignSegment(viewMinX, viewMinY, viewMaxX, viewMaxY, headPos.x, headPos.y, tailPos.x, tailPos.y)
  else
    local stationPos = self.stations[headStationIndex].position
    stationPos = SceneUtils.WorldToUniqueTile(stationPos)
    isInView = SceneUtils.AxisAlignRectIntersectAxisAlignSegment(viewMinX, viewMinY, viewMaxX, viewMaxY, headPos.x, headPos.y, stationPos.x, stationPos.y) or SceneUtils.AxisAlignRectIntersectAxisAlignSegment(viewMinX, viewMinY, viewMaxX, viewMaxY, tailPos.x, tailPos.y, stationPos.x, stationPos.y)
  end
  return isInView
end

function HSRData:GetPosition(timeStamp)
  if timeStamp < self.startTime then
    return self.stations[1].position, self.stations[1].direction, 1, TrainState.BeforeDeparture
  end
  if timeStamp >= self.endTime then
    return self.stations[#self.stations].position, self.stations[#self.stations].direction, #self.stations, TrainState.ArrivedFinal
  end
  local passedTime = timeStamp - self.startTime
  local progress = passedTime * self.frequencyBetweenStations + 1
  local stationIndex = math.floor(progress)
  local percent = progress - stationIndex
  local startPos = self.stations[stationIndex].position
  local endPos = self.stations[stationIndex + 1].position
  local position = Vector3.Lerp(startPos, endPos, percent)
  return position, self.stations[stationIndex].direction, stationIndex, TrainState.Travelling
end

function HSRData:GetPrevStationIndex(timeStamp)
  if timeStamp < self.startTime then
    return 1
  end
  if timeStamp >= self.endTime then
    return #self.stations
  end
  local passedTime = timeStamp - self.startTime
  local progress = passedTime * self.frequencyBetweenStations + 1
  local stationIndex = math.floor(progress)
  return stationIndex
end

function HSRData:DebugSetStartTime(debugTime)
  self.debugTime = debugTime
  self.startTime = debugTime
end

function HSRData:DebugSetStartDirection(direction)
  self.debugDirection = direction
end

function HSRData:GetHeadInfos()
  local now = UITimeManager:GetInstance():GetServerTime()
  local stationIndex = self:GetPrevStationIndex(now)
  if self.passengerStationIndex ~= stationIndex then
    DataCenter.HSRDataManager:FetchActivityDataWithCD(now)
  end
  return self.passengerHeadInfos or {}
end

function HSRData:SetHeadInfos(passengerHeadInfos)
  self.passengerHeadInfos = passengerHeadInfos
  local now = UITimeManager:GetInstance():GetServerTime()
  local stationIndex = self:GetPrevStationIndex(now)
  self.passengerStationIndex = stationIndex
  EventManager:GetInstance():Broadcast(EventId.HSRHeadDataRefresh)
end

return HSRData
