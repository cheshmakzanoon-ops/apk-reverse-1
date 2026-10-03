local SeasonSelectCamp_CampData = require("UI.LWSeason6.UILWSeasonSelectCamp.Main.SeasonSelectCamp_CampData")
local SeasonSelectCamp_InfoData = BaseClass("SeasonSelectCamp_InfoData")

function SeasonSelectCamp_InfoData:__init()
  self:Reset()
end

function SeasonSelectCamp_InfoData:__delete()
  self:Reset()
end

function SeasonSelectCamp_InfoData:Reset()
  self.Payload = nil
  self.LastSetTime = 0
  self.LeftCamp = nil
  self.RightCamp = nil
  self.Records = {}
end

function SeasonSelectCamp_InfoData:SetData(payload)
  self:Reset()
  if payload == nil then
    return
  end
  self.Payload = payload
  self.LastSetTime = checknumber(payload.lastsetinmills)
  self:HandleCampInfo(payload)
  self:HandleZone(payload)
  self:HandleRecords(payload)
end

function SeasonSelectCamp_InfoData:ImLeaderServerKing()
  if self.LeftCamp ~= nil and self.LeftCamp.ImLeaderServerKing then
    return true
  end
  if self.RightCamp ~= nil and self.RightCamp.ImLeaderServerKing then
    return true
  end
  return false
end

function SeasonSelectCamp_InfoData:GetLastSetTime()
  return checknumber(self.LastSetTime)
end

function SeasonSelectCamp_InfoData:GetMyCampData()
  if self.LeftCamp ~= nil and self.LeftCamp.ImHere then
    return self.LeftCamp
  end
  if self.RightCamp ~= nil and self.RightCamp.ImHere then
    return self.RightCamp
  end
  return nil
end

function SeasonSelectCamp_InfoData:GetCampDataByPos(pos)
  if pos == 1 then
    return self.LeftCamp
  end
  if pos == 2 then
    return self.RightCamp
  end
  return nil
end

function SeasonSelectCamp_InfoData:GetLeftResultIcon()
  return self:GetCampResultIcon(self.LeftCamp)
end

function SeasonSelectCamp_InfoData:GetRightResultIcon()
  return self:GetCampResultIcon(self.RightCamp)
end

function SeasonSelectCamp_InfoData:GetCampResultIcon(campData)
  local selectId = 0
  if campData ~= nil and not table.IsNullOrEmpty(self.Records) and campData.LeaderServer ~= nil then
    local leaderServerId = checknumber(campData.LeaderServer.ServerId)
    for _, record in ipairs(self.Records) do
      if record.Sid == leaderServerId then
        selectId = checknumber(record.Value)
        break
      end
    end
  end
  local icons = DataCenter.SeasonSelectCampManager.Icons
  return icons[Mathf.Clamp(checknumber(selectId), 0, 2)]
end

function SeasonSelectCamp_InfoData:HandleSelect(payload)
  if payload == nil then
    return
  end
  if checknumber(payload.lastsetinmills) > 0 then
    self.LastSetTime = checknumber(payload.lastsetinmills)
  end
  local myCamp = self:GetMyCampData()
  if myCamp ~= nil then
    myCamp:HandleSelect(payload)
  end
end

function SeasonSelectCamp_InfoData:HandleSelectTime(payload)
  if payload ~= nil and checknumber(payload.lastsetinmills) > 0 then
    self.LastSetTime = checknumber(payload.lastsetinmills)
  end
end

function SeasonSelectCamp_InfoData:HandleCampInfo(payload)
  self.LeftCamp = self.LeftCamp or SeasonSelectCamp_CampData.New()
  self.LeftCamp:SetData(payload, 1)
  self.RightCamp = self.RightCamp or SeasonSelectCamp_CampData.New()
  self.RightCamp:SetData(payload, 2)
  self.ServerCamp = {}
  if not table.IsNullOrEmpty(payload.sid2camp) then
    for serverId, campId in pairs(payload.sid2camp) do
      self.ServerCamp[serverId] = checknumber(campId)
    end
  end
end

function SeasonSelectCamp_InfoData:HandleZone(payload)
  self.ServerZone = {}
  if not table.IsNullOrEmpty(payload.sid2zone) then
    for serverId, zoneIndex in pairs(payload.sid2zone) do
      self.ServerZone[serverId] = checknumber(zoneIndex)
    end
  end
end

function SeasonSelectCamp_InfoData:HandleRecords(payload)
  self.Records = {}
  if not table.IsNullOrEmpty(payload.records) then
    for _, record in ipairs(payload.records) do
      local recordData = {}
      recordData.Uid = checknumber(record.uid)
      recordData.Time = checknumber(record.time)
      recordData.Value = checknumber(record.v)
      recordData.KingInfo = BasePlayerInfo.New()
      recordData.KingInfo:ParseData(record.userinfo)
      recordData.Sid = checknumber(record.sid)
      recordData.IsUserCreated = record.isUserCreated
      table.insert(self.Records, recordData)
    end
  end
  table.sort(self.Records, function(a, b)
    return a.Time > b.Time
  end)
end

return SeasonSelectCamp_InfoData
