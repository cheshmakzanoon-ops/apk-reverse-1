local CampWarManager = BaseClass("CampWarManager")

function CampWarManager:__init()
  self:AddListener()
end

function CampWarManager:__delete()
  self:RemoveListener()
end

function CampWarManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.SaveOwnPositionId, self.SaveOwnPositionId, self)
end

function CampWarManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():RemoveListener2(EventId.SaveOwnPositionId, self.SaveOwnPositionId, self)
end

function CampWarManager:InitData(data)
  if data and not table.IsNullOrEmpty(data.campRankList) and data.initServerGroup and data.initServerGroup.group then
    local rankValue = {}
    for i, v in ipairs(data.campRankList) do
      rankValue[v] = i
    end
    local campAServerLeader, campBServerLeader = -1, -1
    if data.curVsRound then
      for i, v in ipairs(data.curVsRound) do
        if v.campId == SeasonFactionType.Rebels then
          campAServerLeader = v.campHeadServer or -1
        elseif v.campId == SeasonFactionType.Gendarmerie then
          campBServerLeader = v.campHeadServer or -1
        end
      end
    end
    if data.initServerGroup.group.a then
      table.sort(data.initServerGroup.group.a, function(a, b)
        if a == campAServerLeader then
          return true
        elseif b == campAServerLeader then
          return false
        end
        return (rankValue[a] or 0) < (rankValue[b] or 0)
      end)
    end
    if data.initServerGroup.group.b then
      table.sort(data.initServerGroup.group.b, function(a, b)
        if a == campBServerLeader then
          return true
        elseif b == campBServerLeader then
          return false
        end
        return (rankValue[a] or 0) < (rankValue[b] or 0)
      end)
    end
  end
  self:RequestAreaExchangeInfo()
end

function CampWarManager.getters:ExchangeRequestFinalStatus()
  return {
    PENDING = 0,
    CANCELLED = 1,
    REJECTED = 2,
    ACCEPTED = 3
  }
end

function CampWarManager.getters:ExchangeRequestReasonCode()
  return {
    UNKNOWN = -1,
    SUCCESS = 0,
    REQUEST_INITIATED = 100,
    INITIATOR_CANCELLED = 101,
    TARGET_ACCEPTED_OTHER_REQUEST = 102,
    INITIATOR_ACCEPTED_OTHER_REQUEST = 103,
    TARGET_OFFICIAL_REJECTED = 201,
    INITIATOR_EXCHANGE_LIMIT_EXCEEDED = 202,
    TARGET_AGREED_TO_EXCHANGE = 301
  }
end

function CampWarManager:OnEnterWorld()
  self.areaHistoryList = nil
end

function CampWarManager:SaveOwnPositionId(positionId)
  self:RequestAreaExchangeInfo()
end

function CampWarManager:RequestAreaExchangeInfo()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not self.requestTimeStamp or curTime - self.requestTimeStamp > 3000 then
    if SeasonUtil.IsInSeasonDarknessMode() and DataCenter.ZoneWarManager:IsCampBattle() and self:CanOperateAreaOverview() and curTime < self:GetExchangeEndTime() then
      self.requestTimeStamp = curTime
      SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeInfo)
    else
      self.areaExchangeList = nil
      self:UpdateExchangeList()
    end
  end
end

function CampWarManager:GetAreaOverview(serverId_)
  serverId_ = serverId_ or LuaEntry.Player:GetSourceServerId()
  if self.areaOverView then
    for _, campData in pairs(self.areaOverView) do
      for _, areaData in ipairs(campData) do
        if areaData.serverId == serverId_ then
          return areaData
        end
      end
    end
  end
end

function CampWarManager:CanOperateAreaOverview(showTips)
  local p = LuaEntry.Player
  local serverId = p:GetSourceServerId()
  if not p:IsPosition(10001, serverId) and not p:IsFirstLady(serverId) then
    if showTips then
      UIUtil.ShowTipsId(393018)
    end
    return false
  end
  return true
end

function CampWarManager:GetAreaExchangeInfo(cityId)
  if not self.areaExchangeList or table.IsNullOrEmpty(self.areaExchangeList) then
    return nil
  end
  for _, item in ipairs(self.areaExchangeList) do
    if item.targetOriginalCityId == cityId then
      return item
    end
  end
end

function CampWarManager:HasAreaExchangeRequest(serverId)
  if not self.areaExchangeList or table.IsNullOrEmpty(self.areaExchangeList) then
    return false
  end
  serverId = serverId or LuaEntry.Player:GetSourceServerId()
  for _, item in ipairs(self.areaExchangeList) do
    if item.initiatorServerId == serverId then
      return true
    end
  end
  return false
end

function CampWarManager:GetExchangeEndTime()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  local battleTime = configSchedule and configSchedule.breakThroneProtectTime
  if not battleTime then
    return 0
  end
  return battleTime - 60000 * LuaEntry.DataConfig:TryGetNum("battle_camp_item", "k1", 20)
end

function CampWarManager:HasRedPoint()
  if not self.hasRedPoint then
    return false
  end
  if not self:CanOperateAreaOverview() then
    return false
  end
  return true
end

function CampWarManager:UpdateExchangeList()
  local hasRedPoint = false
  if self.areaExchangeList then
    local selfServerId = LuaEntry.Player:GetSourceServerId()
    for _, item in ipairs(self.areaExchangeList) do
      if item.targetServerId == selfServerId then
        hasRedPoint = true
        break
      end
    end
  end
  self.hasRedPoint = hasRedPoint
  EventManager:GetInstance():Broadcast(EventId.CrossThroneStrategicAreaExchangeInfo)
end

local function __SortAreaServer(a, b)
  if a.isLeaderServer ~= b.isLeaderServer then
    return a.isLeaderServer
  end
  return a.selectedCityId < b.selectedCityId
end

function CampWarManager:CrossThroneGetStrategicAreaOverview(list)
  local overview = {}
  if list then
    for _, item in ipairs(list) do
      local campId = item.campId
      if not overview[campId] then
        overview[campId] = {}
      end
      table.insert(overview[campId], item)
    end
    for campId, items in pairs(overview) do
      table.sort(items, __SortAreaServer)
    end
  end
  self.areaOverView = overview
  EventManager:GetInstance():Broadcast(EventId.CrossThroneGetStrategicAreaOverview)
end

local function __SortAreaExchange(a, b)
  if a.requestTime ~= b.requestTime then
    return a.requestTime < b.requestTime
  end
  return a.uuid < b.uuid
end

function CampWarManager:CrossThroneStrategicAreaExchangeInfo(list)
  if list then
    table.sort(list, __SortAreaExchange)
  end
  self.areaExchangeList = list
  self:UpdateExchangeList()
end

function CampWarManager:CrossThroneStrategicAreaExchangeInitiate(request)
  if not self.areaExchangeList then
    self.areaExchangeList = {}
  else
    for i, item in ipairs(self.areaExchangeList) do
      if item.uuid == request.uuid then
        self.areaExchangeList[i] = request
        self:UpdateExchangeList()
        return
      end
    end
  end
  table.insert(self.areaExchangeList, request)
  table.sort(self.areaExchangeList, __SortAreaExchange)
  self:UpdateExchangeList()
end

function CampWarManager:CrossThroneStrategicAreaExchangeCancel(request)
  if table.IsNullOrEmpty(self.areaExchangeList) then
    return
  end
  for i, item in ipairs(self.areaExchangeList) do
    if item.uuid == request.uuid then
      table.remove(self.areaExchangeList, i)
      self:UpdateExchangeList()
      UIUtil.ShowTipsId("season_s4_camp_battle_25")
      return
    end
  end
end

local function __SortHistory(a, b)
  if a.createTime ~= b.createTime then
    return a.createTime > b.createTime
  end
  return a.requestTime > b.requestTime
end

function CampWarManager:CrossThroneStrategicAreaExchangeHistory(list)
  if list then
    table.sort(list, __SortHistory)
  end
  self.areaHistoryList = list
  EventManager:GetInstance():Broadcast(EventId.CrossThroneStrategicAreaExchangeHistory)
end

return CampWarManager
