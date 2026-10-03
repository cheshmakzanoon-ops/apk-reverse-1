local SeasonSelectCamp_CampData = BaseClass("SeasonSelectCamp_CampData")

function SeasonSelectCamp_CampData:__init()
end

function SeasonSelectCamp_CampData:__delete()
end

function SeasonSelectCamp_CampData:Reset()
  self.Pos = 0
  self.SelectId = 0
  self.ResultId = 0
  self.LeaderServer = nil
  self.ServerList = nil
  self.ImHere = false
  self.ImLeaderServerKing = false
  self.MemberServerList = nil
end

function SeasonSelectCamp_CampData:SetData(payload, pos)
  self:Reset()
  self:HandleServerData(payload, pos)
end

function SeasonSelectCamp_CampData:HandleServerData(payload, pos)
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  if seasonConfig == nil then
    return
  end
  local leaderArr = string.string2array_i_oneSep(seasonConfig.camp_sever, "|")
  if pos <= table.count(leaderArr) then
    local leaderServer = leaderArr[pos]
    local serverList = string.string2array_i(seasonConfig.camp_group, "|", ";")
    self.Pos = pos
    self.SelectId = checknumber(table.TryGetValue(payload.sid2selects, checkstring(leaderServer), 0))
    self.ResultId = checknumber(table.TryGetValue(payload.sid2camp, checkstring(leaderServer), 0))
    self.LeaderServer = self:GetServerData(payload, leaderServer, true)
    self.ServerList = {}
    self.ImHere = false
    self.ImLeaderServerKing = false
    self.MemberServerList = {}
    for _, servers in pairs(serverList) do
      if table.hasvalue(servers, leaderServer) then
        self.ServerList = servers
        self.ImHere = table.hasvalue(servers, LuaEntry.Player:GetSourceServerId())
        self.ImLeaderServerKing = self.ImHere and self.LeaderServer.ImKing
        for _, serverId in pairs(servers) do
          if serverId ~= leaderServer then
            self.MemberServerList[serverId] = self:GetServerData(payload, serverId, false)
          end
        end
        break
      end
    end
  end
end

function SeasonSelectCamp_CampData:GetServerData(payload, serverId, isLeader)
  local serverData = {}
  serverData.ServerId = serverId
  serverData.IsLeaderServer = isLeader
  serverData.ImKing = false
  if payload ~= nil then
    for _, president in pairs(payload.presidents) do
      if checknumber(president.serverid) == serverId then
        if president.kinginfo ~= nil then
          serverData.KingInfo = BasePlayerInfo.New()
          serverData.KingInfo:ParseData(president.kinginfo)
          serverData.ImKing = serverData.KingInfo.uid == LuaEntry.Player:GetUid()
        end
        break
      end
    end
  end
  return serverData
end

function SeasonSelectCamp_CampData:HandleSelect(payload)
  if payload == nil then
    return
  end
  self.SelectId = checknumber(payload.v)
end

function SeasonSelectCamp_CampData:HandleResult(payload)
end

function SeasonSelectCamp_CampData:OrderToServerId(order)
  order = checknumber(order)
  assert(1 <= order and order <= 4, "order must be 1-4")
  local leaderServerId = self.LeaderServer.ServerId
  if order == 1 then
    return leaderServerId
  end
  local realIndex = 2
  for i, serverId in ipairs(self.ServerList) do
    if serverId ~= leaderServerId then
      if realIndex == order then
        return serverId
      end
      realIndex = realIndex + 1
    end
  end
  return 0
end

function SeasonSelectCamp_CampData:GetMemberByIndex(index)
  index = Mathf.Clamp(checknumber(index), 1, 4)
  if index == 1 then
    return self.LeaderServer
  end
  local serverId = self:OrderToServerId(index)
  if serverId ~= 0 then
    return self.MemberServerList[serverId]
  end
  return nil
end

function SeasonSelectCamp_CampData:CanShowSelect()
  return self.ImLeaderServerKing
end

function SeasonSelectCamp_CampData:GetSelectIcon(checkAuth)
  local icons = DataCenter.SeasonSelectCampManager.Icons
  if (not checkAuth or self.ImLeaderServerKing) and self.SelectId ~= nil then
    return icons[Mathf.Clamp(checknumber(self.SelectId), 0, 2)]
  end
  return icons[0]
end

function SeasonSelectCamp_CampData:GetServerStrList()
  local serverStrList = {}
  if not table.IsNullOrEmpty(self.ServerList) then
    for _, serverId in pairs(self.ServerList) do
      table.insert(serverStrList, string.format("#%s", serverId))
    end
  end
  return serverStrList
end

return SeasonSelectCamp_CampData
