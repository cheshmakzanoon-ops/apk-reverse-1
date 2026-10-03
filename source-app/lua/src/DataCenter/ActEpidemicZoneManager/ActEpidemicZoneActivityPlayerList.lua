local ActEpidemicZoneActivityPlayerList = BaseClass("ActEpidemicZoneActivityPlayerList")
local ActEpidemicZoneActivityPlayerInfo = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityPlayerInfo")

function ActEpidemicZoneActivityPlayerList:__init()
  self.players = {}
  self.dirty = true
end

function ActEpidemicZoneActivityPlayerList:__delete()
end

function ActEpidemicZoneActivityPlayerList:SyncFromAlliance()
  local allMembers = DataCenter.AllianceMemberDataManager:GetAllMember()
  for k, v in pairs(allMembers) do
    local info = self.players[v.uid]
    if not info then
      info = ActEpidemicZoneActivityPlayerInfo.New(v.uid)
      self.players[v.uid] = info
    end
    info.rank = v.rank
    info.pic = v.pic
    info.picVer = v.picVer
    info.online = v.online
  end
end

function ActEpidemicZoneActivityPlayerList:UpdateAll(playerList)
  if not playerList or not playerList.users then
    return
  end
  local temp = {}
  for k, v in ipairs(playerList.users) do
    local uid = v.uid
    local info = self.players[uid]
    info = info or ActEpidemicZoneActivityPlayerInfo.New(v.uid)
    temp[uid] = info
    info:UpdateFromMsg(v)
  end
  self.players = temp
  self:SyncFromAlliance()
  self.dirty = true
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerListRefresh)
end

function ActEpidemicZoneActivityPlayerList:UpdatePlayer(group, targetUid, state)
  if not state or state == EpidemicZonePlayerState.None then
    group = ActEpidemicUtils.GroupNone
  end
  local info = self.players[targetUid]
  if not info then
    local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(targetUid)
    if not member then
      ActEpidemicUtils.Error("UpdatePlayer %s exception.", targetUid)
      return
    end
    info = ActEpidemicZoneActivityPlayerInfo.New(targetUid)
    self.players[targetUid] = info
    info:UpdateAllianceMember(member)
    info:RefreshGroupAndState(group, state)
  else
    info:RefreshGroupAndState(group, state)
  end
  self.dirty = true
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerListRefresh)
end

function ActEpidemicZoneActivityPlayerList:UpdateMyApply(group)
  local myInfo = self:GetPlayer(LuaEntry.Player.uid)
  if not myInfo then
    ActEpidemicUtils.LogError("Update my apply failed.")
    return
  end
  myInfo.apply = group
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerApplyRefresh)
end

function ActEpidemicZoneActivityPlayerList:GetPlayer(uid)
  return self.players[uid]
end

function ActEpidemicZoneActivityPlayerList:Recalculate()
  if self.dirty then
    self.dirty = false
    self.groupAByRank = {}
    self.groupAByRank.ranks = {}
    self.groupAByRank.main = 0
    self.groupAByRank.sub = 0
    self.groupBByRank = {}
    self.groupBByRank.ranks = {}
    self.groupBByRank.main = 0
    self.groupBByRank.sub = 0
    for k, v in pairs(self.players) do
      local group = v.group
      local rank = v.rank
      local state = v.state
      local _tab, _tabAll
      if group == ActEpidemicUtils.Group1 then
        _tab = self.groupAByRank.ranks
        _tabAll = self.groupAByRank
      elseif group == ActEpidemicUtils.Group2 then
        _tab = self.groupBByRank.ranks
        _tabAll = self.groupBByRank
      end
      if _tab then
        local _rankTab = _tab[rank]
        if not _rankTab then
          _rankTab = {}
          _tab[rank] = _rankTab
          _rankTab.main = 0
          _rankTab.sub = 0
          _rankTab.players = {}
        end
        if state == EpidemicZonePlayerState.Main then
          _rankTab.main = _rankTab.main + 1
          _tabAll.main = _tabAll.main + 1
          table.insert(_rankTab.players, v)
        elseif state == EpidemicZonePlayerState.Sub then
          _rankTab.sub = _rankTab.sub + 1
          _tabAll.sub = _tabAll.sub + 1
          table.insert(_rankTab.players, v)
        end
      end
    end
  end
end

function ActEpidemicZoneActivityPlayerList:GetSummaryByGroupAndRank(group, rank)
  self:Recalculate()
  local _g
  if group == ActEpidemicUtils.Group1 then
    _g = self.groupAByRank.ranks
  elseif group == ActEpidemicUtils.Group2 then
    _g = self.groupBByRank.ranks
  end
  local tab = _g ~= nil and _g[rank] or nil
  if not tab then
    return 0, 0
  else
    return tab.main or 0, tab.sub or 0
  end
end

function ActEpidemicZoneActivityPlayerList:GetSummaryByGroup(group)
  self:Recalculate()
  local _g
  if group == ActEpidemicUtils.Group1 then
    _g = self.groupAByRank
  elseif group == ActEpidemicUtils.Group2 then
    _g = self.groupBByRank
  end
  if not _g then
    return 0, 0
  end
  return _g.main or 0, _g.sub or 0
end

function ActEpidemicZoneActivityPlayerList:GetPlayersByGroup(group)
  local _ = {}
  for k, v in pairs(self.players) do
    if v and v.group == group then
      table.insert(_, v)
    end
  end
  return _
end

local empty = {}

function ActEpidemicZoneActivityPlayerList:GetPlayerListByGroupAndRank(group, rank)
  self:Recalculate()
  local _g
  if group == ActEpidemicUtils.Group1 then
    _g = self.groupAByRank.ranks
  elseif group == ActEpidemicUtils.Group2 then
    _g = self.groupBByRank.ranks
  end
  return _g[rank] and _g[rank].players or empty
end

function ActEpidemicZoneActivityPlayerList:Description()
  local sb = StringBuilder.New()
  local groupA = {}
  local groupB = {}
  local groupNone = {}
  local exception = {}
  for k, v in pairs(self.players) do
    local info = v
    if info.group == ActEpidemicUtils.Group1 then
      table.insert(groupA, info)
    elseif info.group == ActEpidemicUtils.Group2 then
      table.insert(groupB, info)
    elseif info.group == ActEpidemicUtils.GroupNone then
      table.insert(groupNone, info)
    else
      table.insert(exception, info)
    end
  end
  sb:AppendFormatLine("\230\136\144\229\145\152\230\149\176\233\135\143\229\144\136\232\174\161:%s", table.count(self.players))
  sb:AppendFormatLine("A\231\187\132\230\136\144\229\145\152\233\135\143:%s", #groupA)
  sb:AppendFormatLine("B\231\187\132\230\136\144\229\145\152\233\135\143:%s", #groupB)
  sb:AppendFormatLine("None\231\187\132\230\136\144\229\145\152\233\135\143:%s", #groupNone)
  sb:AppendFormatLine("\229\188\130\229\184\184\230\136\144\229\145\152\230\149\176\233\135\143:%s", #exception)
  sb:AppendLine()
  if 0 < #groupA then
    sb:AppendFormatLine("---A\231\187\132\230\136\144\229\145\152\232\175\166\230\131\133---")
    for k, v in ipairs(groupA) do
      sb:AppendFormatLine(v:Description())
    end
    sb:AppendFormatLine("------")
  end
  sb:AppendLine()
  if 0 < #groupB then
    sb:AppendFormatLine("---B\231\187\132\230\136\144\229\145\152\232\175\166\230\131\133---")
    for k, v in ipairs(groupB) do
      sb:AppendFormatLine(v:Description())
    end
    sb:AppendFormatLine("------")
  end
  sb:AppendLine()
  if 0 < #groupNone then
    sb:AppendFormatLine("---None\231\187\132\230\136\144\229\145\152\232\175\166\230\131\133---")
    for k, v in ipairs(groupNone) do
      sb:AppendFormatLine(v:Description())
    end
    sb:AppendFormatLine("------")
  end
  sb:AppendLine()
  if 0 < #exception then
    sb:AppendFormatLine("--\229\188\130\229\184\184\230\136\144\229\145\152\232\175\166\230\131\133---")
    for k, v in ipairs(exception) do
      sb:AppendFormatLine(v:Description())
    end
    sb:AppendFormatLine("------")
  end
  sb:AppendLine()
  self:GetSummaryByGroupAndRank(1, 1)
  if not self.groupAByRank then
    sb:AppendFormatLine("\230\151\160\230\179\149\230\137\190\229\136\176\230\156\128\230\150\176\231\154\132\228\186\186\230\149\176\231\187\159\232\174\161")
  else
    sb:AppendFormatLine("\230\159\165\231\156\139\230\156\128\230\150\176\231\154\132\228\186\186\230\149\176\231\187\159\232\174\161:")
    sb:AppendFormatLine("A\231\187\132:")
    for k, v in pairs(self.groupAByRank.ranks) do
      local main, sub = self:GetSummaryByGroupAndRank(ActEpidemicUtils.Group1, k)
      local players = self:GetPlayerListByGroupAndRank(ActEpidemicUtils.Group1, k)
      sb:AppendFormatLine("rank:%s, main:%s, sub:%s, players:%s", k, main, sub, #players)
    end
    sb:AppendLine()
    sb:AppendFormatLine("B\231\187\132:")
    for k, v in pairs(self.groupBByRank.ranks) do
      local main, sub = self:GetSummaryByGroupAndRank(ActEpidemicUtils.Group2, k)
      local players = self:GetPlayerListByGroupAndRank(ActEpidemicUtils.Group2, k)
      sb:AppendFormatLine("rank:%s, main:%s, sub:%s, players:%s", k, main, sub, #players)
    end
  end
  return sb:ToString()
end

return ActEpidemicZoneActivityPlayerList
