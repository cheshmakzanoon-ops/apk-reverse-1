local HSRStation = BaseClass("HSRStation")

function HSRStation:__init(serverId, position, direction, stationId)
  self.serverId = serverId
  self.position = position
  self.direction = direction
  self.stationId = stationId
end

function HSRStation:__delete()
  self.serverId = nil
  self.position = nil
  self.direction = nil
  self.stationId = nil
end

return HSRStation
