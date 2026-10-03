local SeasonSelectLocationPosData = BaseClass("SeasonSelectLocationPosData")

function SeasonSelectLocationPosData:__init(payload)
  self.ServerData = {}
  self.PosData = {}
end

function SeasonSelectLocationPosData:__delete()
end

function SeasonSelectLocationPosData:Update(payload, trigger)
  self:HandlePayload(payload)
  if trigger then
    EventManager:GetInstance():Broadcast(EventId.SeasonSelectLocationPosDataUpdate, self)
  end
end

function SeasonSelectLocationPosData:UpdateSingle()
end

function SeasonSelectLocationPosData:HandlePayload(payload)
  self.ServerData = {}
  self.PosData = {}
  if not table.IsNullOrEmpty(payload.pos2sid) then
    for pos, serverId in pairs(payload.pos2sid) do
      local iServerId = checknumber(serverId)
      self.ServerData[iServerId] = self.ServerData[iServerId] or {}
      self.ServerData[iServerId].ServerId = iServerId
      self.ServerData[iServerId].Pos = checknumber(pos)
      self.ServerData[iServerId].Score = 0
      self.ServerData[iServerId].Time = 0
    end
  end
  if not table.IsNullOrEmpty(payload.sid2score) then
    for serverId, scoreStr in pairs(payload.sid2score) do
      local pair = string.split(checkstring(scoreStr), ".")
      if table.count(pair) == 2 then
        local iServerId = checknumber(serverId)
        if self.ServerData[iServerId] == nil then
          self.ServerData[iServerId] = {}
          self.ServerData[iServerId].Pos = -1
          self.ServerData[iServerId].ServerId = iServerId
        end
        local score = checknumber(pair[1])
        local time = checknumber(pair[2])
        self.ServerData[iServerId].Score = score
        self.ServerData[iServerId].Time = time
      end
    end
  end
  local curServerId = LuaEntry.Player.serverId
  if self.ServerData[curServerId] == nil then
    self.ServerData[curServerId] = {}
    self.ServerData[curServerId].Pos = -1
    self.ServerData[curServerId].ServerId = curServerId
    self.ServerData[curServerId].Score = 0
    self.ServerData[curServerId].Time = 0
  end
  self.ServerData[curServerId].LastSetTime = checknumber(payload.lastsettime)
  if not table.IsNullOrEmpty(payload.pos2sid) then
    for pos, serverId in pairs(payload.pos2sid) do
      self.PosData[checknumber(pos)] = self.ServerData[checknumber(serverId)]
    end
  end
end

function SeasonSelectLocationPosData:GetMyData()
  local curServerId = LuaEntry.Player.serverId
  return self:GetServerData(curServerId)
end

function SeasonSelectLocationPosData:GetServerData(serverId)
  return self.ServerData[serverId]
end

function SeasonSelectLocationPosData:GetPosData(pos)
  return self.PosData[pos]
end

function SeasonSelectLocationPosData:GetNextSetTime()
  local actData = DataCenter.SeasonSelectLocationManager:GetActData()
  if actData ~= nil then
    local cd = checknumber(actData.SetCd)
    local myInfo = self:GetMyData()
    if myInfo == nil then
      return 0, 0
    end
    local lastSetTime = checknumber(myInfo.LastSetTime)
    return lastSetTime, lastSetTime + cd
  end
  return LongMaxValue, LongMaxValue
end

function SeasonSelectLocationPosData:IsCdValid()
  local lastSetTime, nextSetTime = self:GetNextSetTime()
  return nextSetTime <= UITimeManager:GetInstance():GetServerSeconds(), nextSetTime
end

function SeasonSelectLocationPosData:GetPosName()
end

return SeasonSelectLocationPosData
